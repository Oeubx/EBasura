# Module 7 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Garbage Collection Schedules
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-7-garbage-collection-schedules-ebasura-m7-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-7-garbage-collection-schedules-ebasura-m7-f)
- **Primary Feature Codes**: `[EBASURA-M7-F0]`, `[EBASURA-M7-F1]`, `[EBASURA-M7-F2]`, `[EBASURA-M7-F3]`, `[EBASURA-M7-F4]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M7-F0` | Schedule Directory Discovery | Unfiltered timetable listing all dates and routes in chronological order without street search. | Street-filtered schedule view auto-detecting the authenticated user's registered street. |
| `EBASURA-M7-F0` | Citizen Pickup Awareness | Users must manually navigate to schedules view to check the next collection date. | Live "Next Pickup Countdown" card embedded directly on the homepage (`PageHomepageWidget`). |
| `EBASURA-M7-F2` | Admin Schedule Creation | Basic text fields for pickup times without time-picker constraints, risking format anomalies. | Validated date-range and time-window pickers preventing retroactive schedule entry. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Citizen Engagement & Schedule Proximity (`EBASURA-M7-F0`)
- **Root Cause**:
  Placing collection schedules behind multiple navigation layers in `PageViewSubFeaturesWidget` led to low citizen awareness. Residents frequently missed collection trucks, leading to uncollected roadside trash.
- **Optimization Strategy**:
  Surface upcoming collections directly on the home screen (`PageHomepageWidget`) via a dynamic query linking `currentUser.street` to the nearest upcoming date in `CollectionTable`. Display a countdown badge (e.g. "Pickup in 4 hours — Biodegradable Only").

### 2.2 Date and Time Format Consistency (`EBASURA-M7-F2`, `EBASURA-M7-F4`)
- **Root Cause**:
  Schedules authored without strict ISO-8601 formatting resulted in string sorting discrepancies in Postgrest queries.
- **Optimization Strategy**:
  Enforce standardized UTC timestamp storage in Postgres, and display localized 12-hour AM/PM formats in the Flutter UI using `intl`'s `DateFormat.jm()`.
