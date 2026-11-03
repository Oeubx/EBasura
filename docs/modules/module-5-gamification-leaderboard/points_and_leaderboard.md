# Points Calculation Engine & Community Leaderboard

## 1. Scope & Responsibility
Documents the server-side point calculation rules, immutable ledger tracking in Supabase, automated database triggers, anti-gaming rate limits, and real-time periodic and street leaderboard architectures.

---

## 2. Standardized Points Awarding Rules & Anti-Gaming Limits

Points are awarded exclusively from **admin-verified scans (`admin_*` columns)** and resolved incident reports adhering strictly to Human-in-the-Loop (HITL) principles. Preliminary AI inferences never award points.

| Action Event | Reason Code | Point Value | Daily Anti-Gaming Limits & Rules |
| :--- | :--- | :---: | :--- |
| **Verified Waste Scan** | `SCAN_VERIFIED` | `+10 pts` | Admin verified scan (`status = 'Verified'`). Capped at **max 3 point-earning scans per resident per day** (Asia/Manila timezone). |
| **Proper Waste Segregation** | `SEGREGATED_BONUS` | `+15 pts` | Admin confirmed segregated (`admin_classification = 'Segregated'`). Capped at **max 1 bonus per resident per day**. |
| **Recyclable Waste Bonus** | `RECYCLABLE_BONUS` | `+5 pts` | Admin confirmed recyclable (`admin_waste_type ILIKE '%Recyclable%'`). |
| **Resolved Incident Report** | `REPORT_RESOLVED` | `+25 pts` | Community waste incident report verified and marked `'Resolved'` by administrator. |
| **Audit Reversal** | `REVERSAL` | `-10 to -30 pts` | Exact negative offsetting automatically created if a previously verified image is flagged, rejected, or deleted. |
| **Guest / Anonymous Scan** | N/A | `0 pts` | Guest uploads (`img_uploader = null`) never award points to preserve leaderboard integrity. |

---

## 3. Server-Side Points Ledger Architecture

All point mutations are managed entirely on the database layer to eliminate client-side race conditions, unauthorized mutations, and ledger drift.

### 3.1 Database Schema (`points_ledger`)
```sql
CREATE TABLE public.points_ledger (
    ledger_id    BIGSERIAL PRIMARY KEY,
    user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    points       INTEGER NOT NULL,
    reason_code  VARCHAR(30) NOT NULL,
    image_id     TEXT NULL,
    report_id    UUID NULL REFERENCES "public"."Report"(report_id) ON DELETE SET NULL,
    street_ref   TEXT NULL,
    created_by   UUID NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT timezone('Asia/Manila', now()),
    CONSTRAINT uq_award_once UNIQUE (user_id, image_id, reason_code)
);
```

### 3.2 Automated Triggers
1. **`trg_image_points`** (`AFTER UPDATE OF status ON "public"."Image"`):
   - Invokes `fn_image_points()`.
   - When an image transitions to `'Verified'`, enforces daily caps and inserts award rows into `points_ledger`.
   - When an image transitions out of `'Verified'` (flagged or deleted), automatically queries and inserts negative reversal rows into `points_ledger`.
2. **`trg_sync_user_points`** (`AFTER INSERT ON public.points_ledger`):
   - Invokes `fn_sync_user_points()`.
   - Recomputes `SUM(points)` from `points_ledger` and atomically updates `"User Subtable".user_points`.
   - Automatically invokes `fn_update_user_streak` and `fn_evaluate_badges` for behavior milestones.

---

## 4. Leaderboard v2 Architecture (`PageLeaderboardWidget`)

- **Location**: `lib/page_leaderboard/`
- **Route**: `/pageLeaderboard`

### 4.1 Time Periods
The leaderboard supports dynamic temporal filtering:
- **This Week** (`this_week`): Filters points from Monday 00:00:00 Asia/Manila to the present.
- **This Month** (`this_month`): Filters points from the 1st day of the current month Asia/Manila.
- **All-Time** (`all_time`): Aggregates all historical verified points ledger entries.

### 4.2 Resident Leaderboard (`get_leaderboard`)
Stored procedure returning ranked individual standings:
- **Top 3 Podium**: Gold (1st), Silver (2nd), and Bronze (3rd) leaders displayed with avatar, medal pill, and total points.
- **Ranked List**: Scrollable ranked entries showing rank index, display name, street zone, and points.
- **Sticky Current User Standing**: Pinned bottom bar displaying active user's rank, points, and deficit points required to overtake the next resident.

### 4.3 Collaborative Streets Leaderboard (`get_street_leaderboard`)
Stored procedure aggregating community waste compliance across barangay streets:
- **Fair Normalization**: Ranks streets by **points per active resident** (`total_points / active_residents`) rather than raw population to prevent large streets from unfairly dominating smaller zones.
- **Interactive Street Drilldown**: Tapping any street opens `PStreetViewOneWidget` for full street schedule and cleanliness inspection.

### 4.4 User Privacy Controls
Residents can configure their public leaderboard visibility in **Profile Settings** (`PageProfileSettingsWidget`):
- `full_name`: Displays resident full name (e.g., *"Juan Dela Cruz"*).
- `initials`: Masks name to initials (e.g., *"J. D."*).
- `anonymous`: Fully anonymizes standing (e.g., *"Neighbor #4812"*).
Masking is applied directly inside stored procedures before returning payloads across network boundaries.
