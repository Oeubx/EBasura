# Badge Administration & Asset Authoring

## 1. Scope & Responsibility
Documents the creation, icon uploading, criteria configuration, and deletion of gamification achievement badges by administrators.

---

## 2. Component Specifications

### 2.1 Badge Creation Modal (`CBadgesCreationWidget`)
- **Location**: `lib/admin/badges/c_badges_creation/`
- **Fields**:
  - `name`: Name of the new badge.
  - `description`: Text explaining the achievement requirements.
  - `pointsRequired`: Minimum points required for unlock.
  - `iconFile`: Vector/PNG asset uploaded to Supabase Storage bucket (`badge_icons/`).
- **Validation**:
  - Ensures non-empty badge name and valid positive integer points requirement.
  - Verifies image asset format.

### 2.2 Badge Deletion Modal (`CBadgesDeletionWidget`)
- **Location**: `lib/admin/badges/c_badges_deletion/`
- **Permissions**: Administrators only.
- **Workflow**:
  - Confirms deletion.
  - Removes icon asset from storage bucket.
  - Deletes record from `badge` table and cascades user badge associations.
