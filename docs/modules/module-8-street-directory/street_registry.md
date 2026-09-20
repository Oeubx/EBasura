# Street Registry & Directory Views

## 1. Scope & Responsibility
Documents the public street registry, search indexing, and profile detail screens for community streets.

---

## 2. Component Specifications

### 2.1 Street Directory (`PStreetViewAllWidget`)
- **Location**: `lib/admin/street/p_street_view_all/`
- **Route**: `/pStreetViewAll`
- **Capabilities**:
  - Displays all registered streets in the municipality/community.
  - Search bar allows instant filtering by street name or sector.
  - Tapping a street card opens `PStreetViewOneWidget`.

### 2.2 Street Details (`PStreetViewOneWidget`)
- **Location**: `lib/admin/street/p_street_view_one/`
- **Route**: `/pStreetViewOne`
- **Parameters**: `streetsRef` (`StreetRow` Supabase reference).
- **Capabilities**:
  - Displays official street name, zone/barangay, and active status.
  - Cross-references collection schedules: lists next scheduled pickup for this street.
  - Lists recent waste reports or uploads associated with this street.
  - Admin controls: Edit or delete street.
