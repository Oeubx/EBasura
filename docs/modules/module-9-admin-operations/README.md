# Module 9: Administrator Operations & User Management

## 1. Overview
Module 9 provides administrative command and governance tools for EBasura. Privileged administrators can monitor high-level metrics, moderate user accounts, manage badges, and audit flagged images to maintain platform safety and data integrity.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M9-F0` | Central Admin Operations Dashboard | Active | `lib/admin/page_admin_dashboard/` | [`admin_dashboard.md`](admin_dashboard.md) |
| `EBASURA-M9-F1` | User Management Console & Auditing | Active | `lib/admin/page_user_management/` | [`user_management.md`](user_management.md) |
| `EBASURA-M9-F2` | User Role Assignment & Suspension | Active | `lib/backend/supabase/database/tables/user.dart` | [`user_management.md`](user_management.md) |
| `EBASURA-M9-F3` | Admin Badge Authoring & Asset Upload | Active | `lib/admin/badges/c_badges_creation/` | [`badge_administration.md`](badge_administration.md) |
| `EBASURA-M9-F4` | Badge Revocation & Deletion | Active | `lib/admin/badges/c_badges_deletion/` | [`badge_administration.md`](badge_administration.md) |
| `EBASURA-M9-F5` | Flagged & Prompt Injection Queue Review | Active | `lib/admin/page_filtered_images/` | [`admin_dashboard.md`](admin_dashboard.md) |

---

## 3. Submodule Directory

- **[`admin_dashboard.md`](admin_dashboard.md)**: Specifications for the central admin dashboard, statistical widgets, quick action hubs, and flagged content reviews.
- **[`user_management.md`](user_management.md)**: Specifications for the user management console, role elevation/revocation, point adjustments, and status moderation.
- **[`badge_administration.md`](badge_administration.md)**: Specifications for creating new badges, uploading iconography, and deleting obsolete badges.
- **[`optimizations.md`](optimizations.md)**: Architectural modernization specifications, bulk image moderation efficiency, and live KPI dashboard metrics.
