# Account Settings & Security Management

## 1. Scope & Responsibility
Covers user security preferences, email address updates, password rotation, and account preference toggles.

---

## 2. Component Specifications

### 2.1 Settings Hub (`PageProfileSettingsWidget`)
- **Location**: `lib/profile/page_profile_settings/`
- **Route**: `/pageProfileSettings`
- **Options**:
  - Security Navigation: Links to Change Email and Change Password screens.
  - Notification Toggles: Push notification preferences stored in `user_subtable`.
  - Terms & Privacy shortcuts.
  - Session Logout: Dispatches `SupabaseAuthManager.signOut()` and redirects to `LandingPageWidget`.

### 2.2 Change Email (`PageChangeEmailWidget`)
- **Location**: `lib/profile/page_change_email/`
- **Route**: `/pageChangeEmail`
- **Workflow**:
  1. Prompts for new email address.
  2. Executes validation checks to prevent duplicate or invalid formats.
  3. Invokes `SupabaseAuthManager.updateEmail(...)`.
  4. Triggers confirmation notice alerting the user to confirm the verification link dispatched to the new email address.

### 2.3 Change Password (`PageChangePasswordWidget`)
- **Location**: `lib/profile/page_change_password/`
- **Route**: `/pageChangePassword`
- **Workflow**:
  1. Accepts `newPassword` and `confirmPassword`.
  2. Validates string length and consistency.
  3. Invokes `SupabaseAuthManager.updatePassword(...)`.
  4. Provides instantaneous feedback via an informational snackbar/dialog.
