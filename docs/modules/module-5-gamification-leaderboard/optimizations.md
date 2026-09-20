# Module 5 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Gamification, Points System & Badges
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-5-gamification-points-system--badges-ebasura-m5-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-5-gamification-points-system--badges-ebasura-m5-f)
- **Primary Feature Codes**: `[EBASURA-M5-F0]`, `[EBASURA-M5-F1]`, `[EBASURA-M5-F2]`, `[EBASURA-M5-F3]`, `[EBASURA-M5-F4]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M5-F0` | Leaderboard Query Scope | Fetches all registered users in a single unbounded stream, causing heavy payload overhead as user count grows. | Capped leaderboard query (Top 50) with pagination and an indexed rank calculation. |
| `EBASURA-M5-F0` | Unranked User Experience | If the current user is ranked outside the top visible slots, they must scroll indefinitely to find their score. | Pinned sticky bottom card displaying the current user's personal rank, total points, and distance to next rank. |
| `EBASURA-M5-F2` | Badge Milestone Evaluation | Milestone checks execute repeatedly on client-side screen rebuilds. | Event-driven milestone trigger executed immediately after valid waste scans or approved incident reports. |
| `EBASURA-M5-F4` | Public Badge Directory | Uncached remote PNG assets reload on every directory visit, causing visual flicker. | Cached network images with vector/SVG icon fallbacks and locked badge opacity cues. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Unbounded Leaderboard Payloads (`EBASURA-M5-F0`)
- **Root Cause**:
  In `lib/page_leaderboard/page_leaderboard_widget.dart`, the user table stream queries all user records sorted by points. In a production environment with hundreds or thousands of community members, streaming every user record over a Realtime WebSocket degrades mobile memory and exhausts Supabase egress bandwidth.
- **Optimization Strategy**:
  Limit the main leaderboard feed to the Top 50 community members (`.limit(50)`). Compute the active user's relative position via a lightweight RPC or index query and pin their personal standing in a sticky bottom banner so they always see their progress without pulling full table snapshots.

### 2.2 Event-Driven Badge Unlocks (`EBASURA-M5-F2`)
- **Root Cause**:
  Evaluating badge milestone criteria during page navigation created redundant database reads on `user_subtable` and `BadgeTable`.
- **Optimization Strategy**:
  Trigger milestone evaluation directly at the point of action: right after `ScanapibyauthenticatedUserCall` confirms a valid waste scan and awards points, check whether `new_total_points >= next_badge.milestone_pts` and atomically insert into `user_badge_junction`.
