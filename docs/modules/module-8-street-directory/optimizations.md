# Module 8 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Street & Community Directory
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-8-street--community-directory-ebasura-m8-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-8-street--community-directory-ebasura-m8-f)
- **Primary Feature Codes**: `[EBASURA-M8-F0]`, `[EBASURA-M8-F1]`, `[EBASURA-M8-F2]`, `[EBASURA-M8-F3]`, `[EBASURA-M8-F4]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M8-F0` | Community Street Index | Static list of streets without real-time search or alphabetical jump index. | Debounced real-time search bar with quick jump alphabet index and street count badge. |
| `EBASURA-M8-F1` | Street Profile & Relations | Street profile view displays basic text info without direct links to related data. | Integrated community hub linking directly to waste reports, pickup schedules, and scans on that street. |
| `EBASURA-M8-F3` | Cascade Deletion Safety | Deleting a street with active collection dates or reports risks foreign key violations. | Pre-deletion dependency audit warning admins if schedules or images are still assigned to the street. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Relational Cross-Linking (`EBASURA-M8-F1`)
- **Root Cause**:
  In `lib/admin/street/p_street_view_one/`, the street profile functioned solely as an administrative record editor. Users and officials had to navigate across separate modules to see reports, images, or collection timetables for that specific neighborhood.
- **Optimization Strategy**:
  Transform the street profile into a centralized community dashboard for each street. Add action chips: "View Scans for this Street" (deep links to `PImagesViewAllWidget` with `selectedStreet`), "View Schedules" (deep links to `PDatesViewAllWidget`), and "Report Waste on this Street".

### 2.2 Foreign Key Integrity Guards (`EBASURA-M8-F3`)
- **Root Cause**:
  Postgres tables `Image`, `Report`, and `Collection` hold foreign keys or string references to `StreetTable`. Deleting a street record without checking dependencies caused orphan references.
- **Optimization Strategy**:
  Add an administrative cascade pre-flight check in `p_street_view_one_widget.dart` that counts dependent records and alerts the administrator before permitting deletion.
