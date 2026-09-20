# Module 7: Garbage Collection Schedules

## 1. Overview
Module 7 provides municipal waste collection scheduling services. Community members can check collection days, time intervals, assigned collectors, and street routes to ensure on-time disposal, while administrators maintain schedule timetables.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M7-F0` | Community Collection Timetable Directory | Active | `lib/admin/dates/p_dates_view_all/` | [`schedule_directory.md`](schedule_directory.md) |
| `EBASURA-M7-F1` | Single Schedule Detail Inspection | Active | `lib/admin/dates/p_dates_view_one/` | [`schedule_directory.md`](schedule_directory.md) |
| `EBASURA-M7-F2` | Admin Collection Schedule Authoring | Active | `lib/admin/dates/c_dates_creation/` | [`schedule_management.md`](schedule_management.md) |
| `EBASURA-M7-F3` | Collection Schedule Deletion & Cancellation | Active | `lib/admin/dates/c_dates_deletion/` | [`schedule_management.md`](schedule_management.md) |
| `EBASURA-M7-F4` | Collection Table Schema & Relations | Active | `lib/backend/supabase/database/tables/collection.dart` | [`schedule_management.md`](schedule_management.md) |

---

## 3. Submodule Directory

- **[`schedule_directory.md`](schedule_directory.md)**: Specifications for public timetable browsing, street-specific filtering, and detail inspection cards.
- **[`schedule_management.md`](schedule_management.md)**: Specifications for administrator schedule creation, timing validations, collector assignment, and database schema mappings.
