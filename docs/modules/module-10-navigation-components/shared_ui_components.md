# Shared UI Components, Alerts & Modals

## 1. Scope & Responsibility
Documents reusable presentation widgets located in `lib/components/` that provide consistent visual language across EBasura.

---

## 2. Component Specifications

### 2.1 Dynamic Role-Based Bottom Navigation Bar (`CBottomBarWidget`)
- **Location**: [`lib/components/c_bottom_bar/`](file:///c:/BiboyStuffs/EBasura/lib/components/c_bottom_bar/)
- **Architecture**: Role-adaptive navigation engine evaluating `RoleService.fetchCurrentUserRole()` on initialization:
  - **Guest (`UserRole.guest`)**:
    - `[ 🏠 Home | 🏆 Rankings | 📷 Camera FAB | 🧭 Explore | 🔑 Sign In ]`
    - Center FAB triggers `PImgUploadAGuestWidget` with `autoTriggerCamera: true`.
    - 5th item renders "Sign In" (`Icons.login_rounded`) directing to authentication.
  - **Resident (`UserRole.resident`)**:
    - `[ 🏠 Home | 🏆 Rankings | 📷 Camera FAB | 🧭 Explore | 👤 Profile ]`
    - Center FAB triggers `PImgUploadAAuthWidget` with `autoTriggerCamera: true` (awards eco-points).
    - 5th item opens personal profile and incident reporting hub ([`PageProfileWidget`](file:///c:/BiboyStuffs/EBasura/lib/profile/page_profile/page_profile_widget.dart)).
  - **Collection Crew (`UserRole.crew`)**:
    - `[ 🚛 Routes | 📋 Pickups | 📷 Camera FAB | ⚠️ Reports | 👤 Profile ]`
    - Direct access to [`PageCrewDashboardWidget`](file:///c:/BiboyStuffs/EBasura/lib/crew/page_crew_dashboard/page_crew_dashboard_widget.dart), street collection checklist, and route-level incident reporting.
  - **Administrator (`UserRole.admin`)**:
    - `[ 📊 Dashboard | 🛡️ Review | 📷 Camera FAB | 👥 Users | 👤 Profile ]`
    - Direct access to admin KPI metrics, image moderation desk ([`PImagesViewAllWidget`](file:///c:/BiboyStuffs/EBasura/lib/image/image_views/p_images_view_all/p_images_view_all_widget.dart)), and user management console.
- **Active State Highlighting**: Detects current active route and applies canonical Ocean Blue (`#2E78A6`) tint to icon and label.

### 2.2 Maintenance Banner (`CMaintenanceWidget`)
- **Location**: [`lib/components/c_maintenance/`](file:///c:/BiboyStuffs/EBasura/lib/components/c_maintenance/)
- **Function**: Rendered during scheduled system maintenance or backend database upgrades to gracefully alert users.

### 2.3 Notification Dialog (`CNotificationWidget`)
- **Location**: [`lib/components/c_notification/`](file:///c:/BiboyStuffs/EBasura/lib/components/c_notification/)
- **Function**: In-app alert dialog for broadcast notices (e.g. holiday garbage collection timetable shifts or community recycling drives).

### 2.4 Informational Dialog Template (`CTemplateInformationalDialogCopyWidget`)
- **Location**: [`lib/components/c_template_informational_dialog_copy/`](file:///c:/BiboyStuffs/EBasura/lib/components/c_template_informational_dialog_copy/)
- **Function**: Standardized modal dialog shell featuring icon header, title, body content, and action dismiss button.
