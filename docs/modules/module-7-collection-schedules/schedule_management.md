# Collection Schedule Administration & Data Schemas

## 1. Scope & Responsibility
Documents administrative schedule authoring, input validations, deletion flows, and the underlying database schema.

---

## 2. Collection Schema (`lib/backend/supabase/database/tables/collection.dart`)
Persisted in the Postgres `collection` table:
- `id`: Primary key (int/uuid).
- `date`: Date or recurring day string.
- `time`: Scheduled time window.
- `street_id`: Foreign key referencing the `street` table.
- `collector`: Name or identifier of assigned waste collection team/vehicle.
- `created_at`: Timestamp.

---

## 3. Administrative Workflows

### 3.1 Schedule Creation Modal (`CDatesCreationWidget`)
- **Location**: `lib/admin/dates/c_dates_creation/`
- **Fields**:
  - `date`: Calendar date selector.
  - `time`: Time picker for collection start and end times.
  - `street`: Dropdown querying active community streets.
  - `collector`: Text input specifying assigned collector or truck identifier.
- **Validation**:
  - Enforces non-null date and time.
  - Prevents duplicate time slots for the same street.

### 3.2 Schedule Deletion Modal (`CDatesDeletionWidget`)
- **Location**: `lib/admin/dates/c_dates_deletion/`
- **Permissions**: Administrators only.
- **Workflow**: Confirms cancellation and removes row from `collection` table.
