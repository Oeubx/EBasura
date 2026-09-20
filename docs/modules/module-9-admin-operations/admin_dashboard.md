# Admin Central Dashboard & Moderation

## 1. Scope & Responsibility
Documents the central administrative control center, platform metrics overview, and flagged content audit routing.

---

## 2. Component Specifications

### 2.1 Admin Dashboard (`PageAdminDashboardWidget`)
- **Location**: `lib/admin/page_admin_dashboard/`
- **Route**: `/pageAdminDashboard`
- **Access Gating**: Strictly restricted to users with `role == 'admin'` in `user` table.
- **UI & Widget Overview**:
  - **Metric Stat Cards**:
    - Total Registered Users
    - Total Waste Scans Performed
    - Pending Waste Incident Reports
    - Active Collection Schedules
  - **Management Hub Links**:
    - User Management Console (`PageUserManagementWidget`)
    - Streets Directory (`PStreetViewAllWidget`)
    - Collection Schedules (`PDatesViewAllWidget`)
    - Waste Reports (`PReportViewAllWidget`)
    - Badges Directory (`PBadgeViewAllWidget`)
    - Filtered & Flagged Images (`PageFilteredImagesWidget`)

### 2.2 Flagged Images Queue (`PageFilteredImagesWidget`)
- **Location**: `lib/admin/page_filtered_images/`
- **Route**: `/pageFilteredImages`
- **Function**: Quarantined list of uploads triggered by the prompt injection guard or flagged by verifiers. Allows admins to inspect the image, view the prompt injection attempt, and delete or permanently ban the submitting account.
