# Identity, Security & Session Management

## 1. Scope & Responsibility
Details the security architecture, email token verification, session lifecycle management, and role-based route guards in EBasura.

---

## 2. Email Verification Flow (`PageVerifyEmailWidget`)
- **Location**: `lib/auth_entry_pages/page_verify_email/`
- **Route**: `/pageVerifyEmail`
- **Parameters**: `userEmail`, `userPassword`, `userConfirmPassword`.
- **Workflow**:
  1. Once user registers, Supabase issues an OTP confirmation token.
  2. `PageVerifyEmailWidget` renders a 6-digit pin code input field.
  3. On submit, invokes Supabase Auth verify OTP API.
  4. On successful verification, the account state transitions to active, automatically authenticating the user and navigating to `PageHomepageWidget`.
  5. Includes "Resend Code" rate-limited action.

---

## 3. Supabase Auth Manager (`SupabaseAuthManager`)
- **Location**: `lib/auth/supabase_auth/supabase_auth_manager.dart`
- **Interfaces**:
  - `createAccountWithEmail(BuildContext context, String email, String password)`
  - `signInWithEmail(BuildContext context, String email, String password)`
  - `signOut()`
  - `resetPassword({required String email, required BuildContext context})`
  - `updateEmail({required String email, required BuildContext context})`
  - `updatePassword({required String newPassword, required BuildContext context})`

---

## 4. User Session Provider (`SupabaseUserProvider`)
- **Location**: `lib/auth/supabase_auth/supabase_user_provider.dart`
- Streams auth state changes (`onAuthStateChange`) from Supabase client:
  - Updates `currentUser` stream consumed by FlutterFlow widgets.
  - Exposes properties: `loggedIn`, `userEmail`, `userUid`.

---

## 5. Security Gates & Role Privileges

| User Tier | Authentication Required | Capabilities | Gated Views |
| :--- | :--- | :--- | :--- |
| **Guest** | No | Read-only feeds, browse collection schedules, perform guest waste scan. | Cannot save scan history, earn points, report waste, or access admin. |
| **Authenticated User** | Yes (Verified Email) | Perform authenticated scans, earn points/badges, submit waste reports, view personal scan history. | Cannot access admin dashboard, user management, or street/schedule modification. |
| **Administrator** | Yes (Admin Role in `user` table) | Full platform control, moderation, user management, street & schedule authoring. | Access to all `/admin` routes. |
