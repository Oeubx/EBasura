# Shared UI Components, Alerts & Modals

## 1. Scope & Responsibility
Documents reusable presentation widgets located in `lib/components/` that provide consistent visual language across EBasura.

---

## 2. Component Specifications

### 2.1 Bottom Navigation Bar (`CBottomBarWidget`)
- **Location**: `lib/components/c_bottom_bar/`
- **Tabs**:
  - `Home`: Navigates to `PageHomepageWidget`.
  - `Schedules`: Navigates to `PDatesViewAllWidget`.
  - `Scanner`: Triggers modal/navigation to `PImgUploadAAuthWidget` (or guest scanner).
  - `Reports`: Navigates to `PReportViewAllWidget`.
  - `Profile`: Navigates to `PageProfileWidget`.
- **Active State Highlighting**: Detects current active route and applies `FlutterFlowTheme.of(context).primary` tint to icon and label.

### 2.2 Maintenance Banner (`CMaintenanceWidget`)
- **Location**: `lib/components/c_maintenance/`
- **Function**: Rendered during scheduled system maintenance or backend database upgrades to gracefully alert users.

### 2.3 Notification Dialog (`CNotificationWidget`)
- **Location**: `lib/components/c_notification/`
- **Function**: In-app alert dialog for broadcast notices (e.g. holiday garbage collection timetable shifts or community recycling drives).

### 2.4 Informational Dialog Template (`CTemplateInformationalDialogCopyWidget`)
- **Location**: `lib/components/c_template_informational_dialog_copy/`
- **Function**: Standardized modal dialog shell featuring icon header, title, body content, and action dismiss button.
