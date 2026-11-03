# **EBasura Dev Plan: Leaderboard, Rewards & Street Compliance Flagging** 

**For:** Prince (Oeubx) · **Branch base:** `feat/rd-update` **Modules:** M5 (Gamification), M8 (Streets), plus small touches in M4/M9 **Concept rule this plan follows:** _"AI result is never final."_ Points, ranks, badges, and street grades are computed **only from admin-verified data (** **`admin_*` columns)** , never from the AI's prediction. 

## **0. Decisions to lock before coding (please confirm or push back)** 

|**#**|**Decision**|**Proposal**|**Why**|
|---|---|---|---|
|D1|What triggers points?|Only the transition to<br>`status =`<br>`'Verified'`. No<br>points at upload time.|Matches the HITL<br>concept and fixes the<br>"verified by Gemini<br>API" rule in<br>`points_and_lead`<br>`erboard.md`.|
|D2|Which classification<br>decides bonuses?|`admin_classific`<br>`ation`/<br>`admin_waste_typ`<br>`e`|Rankings stay fair even<br>when the AI is wrong.|
|D3|Penalty for<br>unsegregated bags?|**0 points, no negative**<br>**points**for individuals|If people lose points<br>they'll stop uploading<br>bad bags. That breaks<br>the dataset and hides<br>the streets that need<br>help. Street flagging<br>handles non-<br>compliance (§4).|
|D4|Points table conflict<br>(+10/+15/+5 vs "+25 to<br>+100")|Use the table in §1.2<br>and update both docs|One rule set.|
|D5|Leaderboard periods|Weekly (main),<br>Monthly, All-time|Weekly resets keep<br>new users motivated.<br>All-time alone gets<br>dominated by early<br>adopters.|
|D6|Who is ranked?|Residents only<br>(exclude<br>admin/crew/guest)|Admins can't compete<br>on data they verify.|
|D7|Invalid scan behavior|Invalid →**retake**<br>(guardrail). Injection<br>detected →**Flagged**.|Resolves the<br>contradiction between<br>the retake doc and the<br>tri-state doc.|



|**#**|**Decision**|**Proposal**|**Why**|
|---|---|---|---|
|D8|Street flags shown<br>publicly?|Street grade is public.<br>**No individual**<br>**household is ever**<br>**named publicly.**|Privacy (Data Privacy<br>Act RA 10173) and<br>avoiding shaming.|



## **1. Phase 1: Points Ledger (foundation)** **`[EBASURA-M5-F1]`** 

### **1.1 Problem with the current design** 

`user_subtable.points` is a single integer that gets incremented in place. That gives no history, no safe rollback when an image is later flagged or deleted, no weekly or monthly totals, and nothing to audit. 

### **1.2 Point rules (proposal)** 

|**Event (all require admin**<br>**verification)**|**Pts**|**Reason code**|
|---|---|---|
|Scan verified (agree or<br>corrected)|+10|`SCAN_VERIFIED`|
|`admin_classification`<br>`= 'Segregated'`|+15|`SEGREGATED_BONUS`|
|`admin_waste_type`<br>includes Recyclable|+5|`RECYCLABLE_BONUS`|
|Incident report resolved as valid|+25|`REPORT_VALID`|
|Streak milestone (see §3)|+20|`STREAK_BONUS`|
|Image later Flagged/deleted<br>after award|−(original)|`REVERSAL`|
|Dispute upheld (AI/admin was<br>wrong, now Verified)|normal award|via`SCAN_VERIFIED`|



#### **Anti-gaming caps** 

- At most **3 point-earning scans per resident per day** . Further scans are still saved for data, but earn 0 points. 

- At most **1** **`SEGREGATED_BONUS` per resident per collection day** . This stops someone photographing one good bag 10 times. 

- _(Optional)_ Perceptual-hash duplicate check: if the image is near-identical to one of the user's last 20 uploads, award 0 points and add a flag hint for the admin. 

### **1.3 Schema** 

```
CREATE TABLE IF NOT EXISTS points_ledger (
```

```
  ledger_id    BIGSERIAL PRIMARY KEY,
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  points       INTEGER NOT NULL,                 -- negative for reversals
  reason_code  VARCHAR(30) NOT NULL,
  image_id     BIGINT NULL,                      -- FK to "Image" (match actual
type)
  report_id    UUID NULL REFERENCES "Report"(report_id) ON DELETE SET NULL,
  street_ref   TEXT NULL,                        -- denormalized for street
leaderboards
  created_by   UUID NULL,                        -- admin who caused it
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_award_once UNIQUE (user_id, image_id, reason_code)  --
idempotency
);
CREATE INDEX ON points_ledger (user_id, created_at);
CREATE INDEX ON points_ledger (street_ref, created_at);
```

- `user_subtable.points` becomes a **cache** equal to `SUM(points_ledger.points)` and is maintained by a trigger. 

- Add `user_subtable.spendable_points` for Phase 5. Redeeming rewards lowers _spendable_ points but never _lifetime_ points, so a resident's rank doesn't drop when they redeem. 

### **1.4 Award logic must run in the database** 

Put the award logic in Postgres and **move it out of the Flutter client** : 

```
-- Fires when an Image row becomes Verified, or leaves Verified
CREATE OR REPLACE FUNCTION fn_image_points() RETURNS trigger AS $$
BEGIN
```

```
  IF NEW.status = 'Verified' AND OLD.status IS DISTINCT FROM 'Verified'
     AND NEW.img_uploader IS NOT NULL THEN
```

```
     -- insert SCAN_VERIFIED / SEGREGATED_BONUS / RECYCLABLE_BONUS
     -- respecting daily caps; ON CONFLICT DO NOTHING (idempotent)
  ELSIF OLD.status = 'Verified' AND NEW.status <> 'Verified' THEN
     -- insert REVERSAL rows negating everything awarded for this image_id
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql SECURITY DEFINER;
```

```
CREATE TRIGGER trg_image_points AFTER UPDATE OF status ON "Image"
FOR EACH ROW EXECUTE FUNCTION fn_image_points();
```

- **RLS:** Residents can `SELECT` only their own ledger rows. No client can `INSERT` into the ledger. Only the trigger or an RPC can. 

- Remove the client-side point increments in `p_img_view_verifier_widget.dart` and the upload pipeline so points aren't awarded twice. 

- Backfill: one-time script that writes ledger rows for existing Verified images, then recomputes the `user_subtable.points` cache. 

### **1.5 Acceptance criteria** 

- ☐ Verifying an image creates the correct ledger rows. Verifying it a second time creates nothing new. 

- ☐ Flagging a previously Verified image creates matching negative `REVERSAL` rows, and the user's total drops back. 

- ☐ The 4th scan of the day is verified but earns 0 points. 

- ☐ A resident cannot insert a ledger row via the REST API (RLS test). 

- ☐ Unit tests: `test/unit/phase9_points_ledger_test.dart` 

## **2. Phase 2: Leaderboard v2** **`[EBASURA-M5-F0]`** 

### **2.1 Features** 

1. **Tabs:** This Week · This Month · All-time (D5). Weeks run Monday 00:00 to Sunday 23:59 PH time ( `Asia/Manila` ). 

2. **Two boards:** 

   - **Residents:** individual ranking. 

   - **Streets:** each street's total points ÷ active residents on that street, so large streets don't win just by size. This gives neighbours a shared goal and connects directly to street compliance (§4). 

3. **Top 50 + pinned "You" card:** shows your rank, your points, and how many points to the next rank (already planned in M5 optimizations; implement through the RPC below). 

4. **Privacy:** add a `leaderboard_display` setting ( `full_name` | `initials` | `hidden` ). Hidden users still earn points but appear as "Anonymous Resident". 

5. **Tie-break:** the user who reached the score first ranks higher ( `MAX(created_at)` ascending). 

### **2.2 RPCs (no client-side sorting of whole tables)** 

```
get_leaderboard(p_period TEXT, p_limit INT DEFAULT 50)
  -- returns rank, user_id, display_name, avatar, points, street_ref
get_my_rank(p_period TEXT)
  -- returns rank, points, points_to_next
get_street_leaderboard(p_period TEXT)
  -- returns rank, street_ref, total_points, active_residents,
points_per_resident
```

All three are implemented as `SUM(points_ledger.points)` filtered by period, using `RANK()` over the result. Add a materialized view refreshed every 15 minutes if it gets slow (it won't at barangay scale). 

### **2.3 UI notes** 

- Keep the existing podium (gold, silver, bronze) and add the period segmented control above it. 

- On the Streets board, tapping a street opens `PStreetViewOneWidget` (ties into M8-F1). 

- Empty state for a new week: _"New week! Be the first to get a verified scan."_ 

### **2.4 Acceptance criteria** 

- ☐ The weekly board resets on Monday PH time, and all-time totals are unchanged. 

- ☐ Admin and crew accounts never appear on the board. 

- ☐ A hidden user shows as "Anonymous Resident" but their rank is correct. 

- ☐ The pinned card is correct for a user ranked #120. 

## **3. Phase 3: Rewards (Badges + Streaks)** **`[EBASURA-M5F2..F4]`** 

Right now badges are just point milestones. We'll add **behavior badges** that reward the _habit_ of segregating, not just volume. 

### **3.1 Badge catalog (seed data, admin-editable via M9-F3)** 

|**Badge**|**Rule (verified data only)**|**Type**|
|---|---|---|
|First Step|1st verified scan|Milestone|
|Segregation Starter|5 verified segregated scans|Behavior|
|Eco Habit|4-week segregation streak|Streak|
|Barangay Champion|12-week streak|Streak|
|Recycler|20 verified recyclable scans|Behavior|
|Watchful Neighbor|3 valid incident reports|Civic|
|Clean Street Hero|Your street holds Grade A for 4<br>straight weeks|Community|
|Points tiers|100 / 500 / 1000 lifetime pts|Milestone|



### **3.2 Streak definition** 

#### **Streak = consecutive collection weeks in which the resident has ≥ 1 Verified scan with** **`admin_classification = 'Segregated'` .** 

- Count weekly, not daily. Collection happens on specific days, so a daily streak would be unfair. 

- Add `user_subtable.current_streak` , `best_streak` , and `streak_updated_week` . 

- **Grace:** one "freeze" per month, so a single missed week (sick, away) doesn't reset the streak. 

- Update the streak inside the same points trigger, or in a weekly cron job (see §4.3). 

### **3.3 Badge rules engine** 

- Add `badge.rule_type` ( `points` | `segregated_count` | `streak` | `report_count` | `street_grade` ) and `badge.rule_threshold INT` . 

- `fn_evaluate_badges(user_id)` runs after each ledger insert and inserts into `user_badge_junction ... ON CONFLICT DO NOTHING` . This is the eventdriven approach already proposed in M5 optimizations, now moved server-side. 

- Unlock UX: a celebratory bottom sheet the next time the app opens. Track this with `user_badge_junction.seen_at IS NULL` . 

### **3.4 Acceptance criteria** 

- ☐ Badges unlock only from Verified data and never unlock twice. 

- ☐ The streak survives one missed week when a freeze is available, and resets when it isn't. 

- ☐ An admin can create a new rule-based badge without changing any code. 

## **4. Phase 4: Street Compliance Index & Flagging** **`[EBASURA-M8F6]` ,** **`[EBASURA-M8-F7]` (new codes)** 

The goal is to flag **streets** where residents are not segregating properly, so the barangay can follow up with an information campaign, a notice, or a visit. Individuals are never flagged publicly. 

### **4.1 Street Compliance Index (SCI), computed weekly** 

For street _s_ in week _w_ , using only `status = 'Verified'` images: 

$$\text{SegRate}_{s,w} = \frac{#\text{verified Segregated}}{#\text{verified scans}}$$ 

$$\text{SCI} _{s,w} = 100 \cdot \text{SegRate}_ {s,w} ;-; 5 \cdot \min(#\text{valid incident reports} _{s,w},,4)$$ 

- **Minimum sample:** at least 5 verified scans in the week. Below that, the street is `Insufficient Data` and gets no grade, so one bad bag can't fail a whole street. 

- **Smoothing:** grade on the **rolling 4-week** SCI, not a single week, so the grade doesn't swing from week to week. 

|**Grade**|**Rolling SCI**|**System action**|
|---|---|---|
|**A**|≥ 85|Green badge on the street;<br>counts toward "Clean Street<br>Hero"|
|**B**|70–84|Neutral|
|**C**|50–69|**Watch**: in-app reminder to<br>residents of that street|
|**D**|< 50|**Flagged**: goes into the admin<br>follow-up queue|



_(The thresholds are a starting point. Tune them after the first 2–4 weeks of trial data and document the final values in the thesis.)_ 

### **4.2 Schema** 

```
CREATE TABLE IF NOT EXISTS street_compliance_snapshot (
  snapshot_id     BIGSERIAL PRIMARY KEY,
  street_ref      TEXT NOT NULL,
  week_start      DATE NOT NULL,
  verified_scans  INT NOT NULL,
  segregated_scans INT NOT NULL,
  valid_reports   INT NOT NULL,
  sci_week        NUMERIC(5,2),
  sci_rolling4    NUMERIC(5,2),
  grade           CHAR(1) NULL,        -- A/B/C/D, NULL = insufficient data
  computed_at     TIMESTAMPTZ DEFAULT now(),
  UNIQUE (street_ref, week_start)
);
CREATE TABLE IF NOT EXISTS street_flag (
  flag_id      BIGSERIAL PRIMARY KEY,
  street_ref   TEXT NOT NULL,
  opened_week  DATE NOT NULL,
  status       VARCHAR(20) NOT NULL DEFAULT 'open'
               CHECK (status IN ('open','notified','in_followup','resolved')),
  action_note  TEXT,                    -- e.g. "IEC flyers distributed 11/12"
  assigned_to  UUID REFERENCES auth.users(id),
  resolved_at  TIMESTAMPTZ,
  created_at   TIMESTAMPTZ DEFAULT now()
);
```

### **4.3 Computation job** 

- `fn_compute_street_compliance(p_week DATE)` fills the snapshot table and opens a `street_flag` when grade = D and no open flag already exists. It automatically suggests `resolved` once the street holds Grade B or better for 2 consecutive weeks. The admin confirms the resolution. 

- Schedule it with **Supabase** **`pg_cron`** every Monday at 01:00 Asia/Manila. Add a manual **"Recompute now"** button on the admin dashboard for demos and the defense. 

### **4.4 UI by role** 

|**Role**|**What they see**|
|---|---|
|**Resident**|Street grade chip on Home + the street profile. If<br>the street is C/D:_"Our street's segregation rate_<br>_is 48% this month. Here's how to segregate_<br>_properly →"_(link to the guide). Nobody is<br>named.|
|**Crew**|On Routes/Pickups, flagged streets show a red<br>marker so the crew can do spot checks on<br>collection day.|
|**Admin**|New**"Street Compliance"**tile on the|



|**Role**|**What they see**|
|---|---|
||dashboard: table of streets with grade, trend<br>arrow, and sample size, plus a**Flag Queue**<br>(open → notified → in follow-up → resolved)<br>where admins add action notes.|
|**Exporter (M8-F5)**|Add the SCI, grade, and flag history columns to<br>the CSV/PDF so the barangay has a report it can<br>file.|



### **4.5 Notifications (optional, if time allows)** 

- When a street becomes Flagged, send a push notification to that street's residents with a neutral, educational message. 

- Notify the assigned admin when a flag is opened. 

### **4.6 Acceptance criteria** 

- ☐ A street with 4 verified scans in the week shows "Insufficient Data", not a grade. 

- ☐ A street with a rolling SCI of 45 creates exactly one open flag. 

- ☐ Two consecutive weeks at B or better suggests resolution. 

- ☐ No resident-facing screen shows another household's name or images in the flag context. 

- ☐ The CSV export includes snapshot history. 

## **5. Phase 5 (optional / stretch): Tangible Rewards Redemption** **`[EBASURA-M5-F8]`** 

Only do this if the barangay agrees to provide items (e.g. eco-bags, rice, load, or recognition certificates). 

- Tables: `reward(reward_id, name, cost_points, stock, active)` and `reward_redemption(id, user_id, reward_id, status: requested| approved|claimed|rejected, created_at)` . 

- Redeeming deducts **spendable** points only. Lifetime points and rank are unchanged. 

- An admin approves each request. The resident shows a claim code at the barangay hall. 

- Without a sponsor, ship **digital recognition only** : a monthly "Top Segregator" certificate generated as a PDF from the exporter. 

## **6. Build order & rough timeline** 

```
flowchart LR
```

```
    P0["P0: Confirm decisions<br/>(½ day)"] --> P1["P1: Points ledger +
```

```
trigger<br/>(2–3 days)"]
    P1 --> P2["P2: Leaderboard v2<br/>(2 days)"]
    P1 --> P4["P4: Street compliance + flags<br/>(3–4 days)"]
    P2 --> P3["P3: Badges + streaks<br/>(2 days)"]
    P4 --> P3
    P3 --> P5["P5: Redemption (stretch)"]
```

P1 is a hard dependency: everything else reads from the ledger. P2 and P4 can be built in parallel after that. 

## **7. New backlog codes to add to** **`EBASURA_Sprint_Backlogs_Commit_Reference.md`** 

|**Code**|**Feature**|
|---|---|
|`EBASURA-M5-F5`|Server-side points ledger, award trigger &<br>reversals|
|`EBASURA-M5-F6`|Periodic (weekly/monthly) & street leaderboards<br>with privacy setting|
|`EBASURA-M5-F7`|Segregation streaks & rule-based badge engine|
|`EBASURA-M5-F8`|Reward redemption (stretch)|
|`EBASURA-M8-F6`|Street Compliance Index weekly snapshots|
|`EBASURA-M8-F7`|Street flag workflow, admin queue & crew<br>markers|



## **8. Docs to update** 

- `module-5-gamification-leaderboard/points_and_leaderboard.md` : replace the points table, add ledger and caps 

- `module-5-gamification-leaderboard/badges_and_achievements.md` : rule types, streaks 

- `module-8-street-directory/street_registry.md` : **add SCI formula, grades, flag workflow** (the thesis roadmap §6.2 cites this file) 

- `retake_guardrail_and_dual_schema.md` : fix the "+25 to +100 pts" line. Also **replace the hard-coded** **`ai_confidence_score = 92.50`** (add `confidence` to the Gemini JSON schema, or drop the column from the analysis). 

- `access_control/crud_matrix.md` : add the new tables and permissions 

## **9. What this gives the thesis** 

- **Ch. 2.5 / 5:** Weekly ledger data lets us chart participation before and after the gamification features launch (scans per week, % segregated over time). 

- **Ch. 6.2:** The street-grade trends and the flag → resolved cycle become real evidence for the governance recommendations. 

- Every number comes from **human-verified** records, which matches the "AI-assisted, 

human-verified" claim we defend. 

