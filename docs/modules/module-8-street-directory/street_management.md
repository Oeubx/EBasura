# Street Administration & Relational Schema

## 1. Scope & Responsibility
Documents administrative street authoring, deletion safeguards, and the underlying database schema.

---

## 2. Street Schema (`lib/backend/supabase/database/tables/street.dart`)
Persisted in the Postgres `street` table:
- `id`: Primary key (int/uuid).
- `name`: Street name (e.g., *"Rizal Street"*, *"Mabini Avenue"*).
- `created_at`: Timestamp.

### Foreign Key Associations:
- `collection.street_id` -> `street.id`
- `report.street_id` -> `street.id`
- `image.street_id` -> `street.id`

---

## 3. Administrative Workflows

### 3.1 Street Creation Modal (`CStreetCreationWidget`)
- **Location**: `lib/admin/street/c_street_creation/`
- **Fields**: `streetName`.
- **Validation**:
  - Non-empty validation.
  - Case-insensitive uniqueness check to prevent duplicate street records.

### 3.2 Street Deletion Modal (`CStreetDeletionWidget`)
- **Location**: `lib/admin/street/c_street_deletion/`
- **Permissions**: Administrators only.
- **Safeguards**:
  - Warns if active collection schedules or pending waste reports reference this street.
  - Removes row from `street` table.
