# Collection Schedule Directory & Inspection

## 1. Scope & Responsibility
Documents the public schedule directory, day/time display, assigned collectors, and street matching views.

---

## 2. Component Specifications

### 2.1 Schedule Directory (`PDatesViewAllWidget`)
- **Location**: `lib/admin/dates/p_dates_view_all/`
- **Route**: `/pDatesViewAll`
- **Capabilities**:
  - Displays a chronological list of scheduled garbage collection dates.
  - Quick filters for streets and upcoming days (e.g. "Today", "This Week").
  - Card summaries display: Collection Day, Time Slot (e.g., *08:00 AM - 10:00 AM*), Target Street, and Assigned Collector.

### 2.2 Schedule Detail View (`PDatesViewOneWidget`)
- **Location**: `lib/admin/dates/p_dates_view_one/`
- **Route**: `/pDatesViewOne`
- **Parameters**: `collectionRef` (`CollectionRow` Supabase reference).
- **Capabilities**:
  - Full schedule breakdown: Specific street route boundaries, truck/collector name, waste types collected on this run (e.g. *Biodegradable only*).
  - Admin quick action button to delete or update schedule.
