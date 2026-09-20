# Module 1 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Authentication, Identity & Security
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-1-authentication-identity--security-ebasura-m1-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-1-authentication-identity--security-ebasura-m1-f)
- **Primary Feature Codes**: `[EBASURA-M1-F0]`, `[EBASURA-M1-F1]`, `[EBASURA-M1-F2]`, `[EBASURA-M1-F3]`, `[EBASURA-M1-F4]`, `[EBASURA-M1-F5]`, `[EBASURA-M1-F6]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M1-F1` | Sign-Up Validation | Form validation executes in sequence on the UI thread without clear error banner feedback. | Pre-flight validation with immediate visual feedback, password strength indicators, and email format regex. |
| `EBASURA-M1-F3` | Sign-In Error Presentation | Raw Supabase error strings (e.g., `AuthApiException: Invalid login credentials`) are exposed to users. | User-friendly localized error dialogs/snackbars explaining credential mismatches and unverified accounts. |
| `EBASURA-M1-F6` | Session Token Refresh Lifecycle | Stale JWT tokens trigger app redirect loop to `LandingPageWidget`. | Silent token refresh mechanism with graceful recovery and session rehydration before UI navigation occurs. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 User-Facing Authentication Exceptions (`EBASURA-M1-F3`)
- **Root Cause**:
  When Supabase returns error responses during authentication attempts, raw server messages are directly passed into scaffold snackbars. These technical messages confuse non-technical users and disclose internal architecture details.
- **Optimization Strategy**:
  Map GoTrue/Supabase error codes (`invalid_credentials`, `email_not_confirmed`, `user_already_exists`) into clear, actionable advice (e.g., "Invalid email or password. Please verify your details or reset your password.").

### 2.2 Token Expiry & Session Refresh Interceptor (`EBASURA-M1-F6`)
- **Root Cause**:
  When users resume the application after prolonged backgrounding, expired JWT access tokens cause immediate 401 Unauthorized errors on initial feed queries before the session can refresh.
- **Optimization Strategy**:
  Configure Supabase GoTrue auto-refresh listeners to verify session health prior to rendering deep-linked authenticated views (`PImagesViewAllUserWidget`, `PageProfileWidget`).
