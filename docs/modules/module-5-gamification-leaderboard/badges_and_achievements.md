# Badges, Milestones & Achievement System

## 1. Scope & Responsibility
Documents the rule-based achievement engine, database junction tracking, weekly behavioral segregation streaks with monthly freeze grace, celebration modals, and administrative badge configuration.

---

## 2. Badge Architecture & Multi-Criterion Rules

Badges are earned dynamically based on verified environmental actions rather than static arbitrary points.

### 2.1 Rule Types (`Badge.rule_type`)
Administrators can configure achievement badges across 5 distinct behavioral criteria:

| Rule Type | Description | Evaluation Basis | Example Badge |
| :--- | :--- | :--- | :--- |
| `points` | Cumulative verified points threshold | `user_points >= rule_threshold` | *"Eco Bronze"* (100 pts), *"Eco Silver"* (300 pts) |
| `segregated_count` | Total verified segregated scans | Count of `points_ledger` rows with `SEGREGATED_BONUS` | *"Segregation Master"* (15 segregated scans) |
| `recyclable_count` | Total verified recyclable scans | Count of `points_ledger` rows with `RECYCLABLE_BONUS` | *"Bottle Collector"* (20 recyclable scans) |
| `report_count` | Total resolved community reports | Count of `Report` rows with `Resolved` status | *"Neighborhood Guardian"* (3 resolved reports) |
| `streak` | Consecutive weekly segregation streak | `"User Subtable".current_streak >= rule_threshold` | *"Consistency Champion"* (4-week streak) |

### 2.2 User Badge Junction (`user_badge_junction`)
Maintains an immutable record of when each user acquired a badge, preventing duplicate awards and tracking celebration notifications:

```sql
CREATE TABLE public.user_badge_junction (
    id          BIGSERIAL PRIMARY KEY,
    user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    badge_id    TEXT NOT NULL,
    awarded_at  TIMESTAMPTZ NOT NULL DEFAULT timezone('Asia/Manila', now()),
    seen_at     TIMESTAMPTZ NULL,
    CONSTRAINT uq_user_badge UNIQUE (user_id, badge_id)
);
```

---

## 3. Weekly Segregation Streaks & Monthly Grace Freezes

To foster sustainable habit formation without punitive dropouts, EBasura implements a weekly streak system with an automated monthly grace freeze:

### 3.1 Weekly Habit Window
- **Streak Evaluation**: Computed every Monday at 00:00:00 Asia/Manila.
- **Requirement**: Resident must submit at least **one verified segregated waste scan** during the calendar week (Monday to Sunday).
- **Streak Increment**: If the condition is met in consecutive weeks, `current_streak` increments by +1.

### 3.2 Monthly Grace Freeze (`freeze_available` & `freeze_used_month`)
- **Grace Policy**: Life events happen. Residents receive **1 streak freeze per calendar month**.
- **Execution**: If a resident has a 1-week gap in submissions and has not used their monthly freeze, the freeze is automatically consumed (`freeze_used_month = 'YYYY-MM'`). Their streak is preserved rather than resetting to zero.
- **Streak Reset**: If 2 or more weeks elapse without submissions, or if the freeze for the month was already consumed, the streak resets to 1 upon the next verified scan.

---

## 4. UI Presentation & Celebratory Dialog

### 4.1 In-App Celebration (`CBadgeCelebrationWidget`)
- **Trigger**: When a resident navigates to `PageProfileWidget`, the app checks for newly unlocked badges where `seen_at IS NULL` via RPC `get_my_unlocked_badges`.
- **Celebration Modal**: Displays high-resolution badge artwork, milestone lore, congratulations copy, and a *"Hooray!"* dismiss action that atomically marks the badge as seen (`mark_badge_seen`).

### 4.2 Profile Shelf (`PageProfileWidget`)
- Displays weekly streak flame chip (`🔥 X Weeks`).
- Displays monthly freeze status chip (`🛡️ Monthly Freeze Active / Used`).
- Showcases all unlocked badges in a horizontal grid with level indicators.

### 4.3 Admin Badge Authoring (`CBadgesCreationWidget`)
- Allows administrators to define badge title, description, level (1–5), visual icon asset, criterion dropdown (`rule_type`), and numerical milestone threshold (`rule_threshold`).
