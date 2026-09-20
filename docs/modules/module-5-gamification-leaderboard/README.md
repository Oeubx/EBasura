# Module 5: Gamification, Points System & Badges

## 1. Overview
Module 5 drives user engagement and civic participation through gamified rewards. By contributing valid waste scans, proper waste segregation, and community incident reports, users earn points that rank them on the community leaderboard and unlock collectible achievement badges.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M5-F0` | Community Leaderboard Ranking | Active | `lib/page_leaderboard/` | [`points_and_leaderboard.md`](points_and_leaderboard.md) |
| `EBASURA-M5-F1` | Points Engine & Ledger Calculation | Active | `lib/backend/supabase/database/tables/user_subtable.dart` | [`points_and_leaderboard.md`](points_and_leaderboard.md) |
| `EBASURA-M5-F2` | Badge Milestone Evaluation & Unlock | Active | `lib/backend/supabase/database/tables/badge.dart` | [`badges_and_achievements.md`](badges_and_achievements.md) |
| `EBASURA-M5-F3` | User Badge Showcase & Details | Active | `lib/admin/badges/p_badge_view_one/` | [`badges_and_achievements.md`](badges_and_achievements.md) |
| `EBASURA-M5-F4` | Public Badge Directory View | Active | `lib/admin/badges/p_badge_view_all/` | [`badges_and_achievements.md`](badges_and_achievements.md) |

---

## 3. Submodule Directory

- **[`points_and_leaderboard.md`](points_and_leaderboard.md)**: Specifications for point accumulation events, leaderboard sorting queries, rank tiers, and ledger consistency in `user_subtable`.
- **[`badges_and_achievements.md`](badges_and_achievements.md)**: Specifications for badge criteria, milestone achievement logic, badge schemas in the `badge` table, and display components.
