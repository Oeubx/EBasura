# Authentication Flows & User Entry Points

## 1. Scope & Purpose
Specifies the UI components, input validation, and navigation flows that guide users through initial discovery, account creation, credentials verification, and session recovery.

---

## 2. Component Specifications

### 2.1 Landing Page (`LandingPageWidget`)
- **Location**: `lib/auth_entry_pages/landing_page/`
- **Route**: `/landingPage` (Default route for unauthenticated visitors)
- **Functions**:
  - Highlights core value propositions: AI Waste Scanning, Garbage Schedules, Gamified Points & Badges.
  - Call-to-action buttons:
    - "Sign In" -> Navigates to `PageSignInWidget`
    - "Sign Up" -> Navigates to `PageSignUpWidget`
    - "Continue as Guest" -> Navigates to `PageHomepageWidget` with guest credentials, allowing read-only access and guest scan.

### 2.2 Sign-Up Screen (`PageSignUpWidget`)
- **Location**: `lib/auth_entry_pages/page_sign_up/`
- **Route**: `/pageSignUp`
- **Fields**:
  - `emailAddress`: Validated against standard email RFC regex.
  - `password`: Enforces minimum length and character complexity.
  - `confirmPassword`: Client-side check ensuring password match.
  - Terms checkbox: Required confirmation before enabling submit.
- **Workflow**:
  - On valid submission, triggers `SupabaseAuthManager.createAccountWithEmail(...)`.
  - Dispatches verification email and redirects user to `PageVerifyEmailWidget`.

### 2.3 Sign-In Screen (`PageSignInWidget`)
- **Location**: `lib/auth_entry_pages/page_sign_in/`
- **Route**: `/pageSignIn`
- **Fields**: `emailAddress`, `password`.
- **Workflow**:
  - Invokes `SupabaseAuthManager.signInWithEmail(...)`.
  - On success, updates `AppStateNotifier`, clearing `_redirectLocation` and pushing to `PageHomepageWidget` (or the intercepted protected target).
  - Handles authentication exceptions (e.g. invalid credentials, unconfirmed email).

### 2.4 Forgot Password (`PageForgotPasswordWidget`)
- **Location**: `lib/auth_entry_pages/page_forgot_password/`
- **Route**: `/pageForgotPassword`
- **Workflow**:
  - Prompts for registered email address.
  - Invokes `SupabaseAuthManager.resetPassword(email)`.
  - Dispatches password recovery link to user's inbox and alerts user via confirmation dialog.

### 2.5 Terms & Conditions (`TermsAndConditionsWidget`)
- **Location**: `lib/auth_entry_pages/terms_and_conditions/`
- **Route**: `/termsAndConditions`
- **Content**: Details user rights, community guidelines on waste reporting, and privacy declarations regarding image uploads.
