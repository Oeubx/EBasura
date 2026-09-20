# Module 1: Authentication, Identity & Security

## 1. Overview
Module 1 manages authentication lifecycles, user onboarding, secure email validation with OTP tokens, session restoration, and role-based access authorization within EBasura. It safeguards backend interactions and controls guest versus authenticated privileges.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M1-F0` | Guest Landing Page & Gateway Entry | Active | `lib/auth_entry_pages/landing_page/` | [`auth_flows.md`](auth_flows.md) |
| `EBASURA-M1-F1` | User Registration & Credential Validation | Active | `lib/auth_entry_pages/page_sign_up/` | [`auth_flows.md`](auth_flows.md) |
| `EBASURA-M1-F2` | Email OTP Verification & Account Activation | Active | `lib/auth_entry_pages/page_verify_email/` | [`identity_and_security.md`](identity_and_security.md) |
| `EBASURA-M1-F3` | Authenticated Sign-In & Session Persistence | Active | `lib/auth_entry_pages/page_sign_in/`, `lib/auth/supabase_auth/` | [`auth_flows.md`](auth_flows.md) |
| `EBASURA-M1-F4` | Password Recovery & Reset Flow | Active | `lib/auth_entry_pages/page_forgot_password/` | [`auth_flows.md`](auth_flows.md) |
| `EBASURA-M1-F5` | Terms and Conditions Acceptance | Active | `lib/auth_entry_pages/terms_and_conditions/` | [`auth_flows.md`](auth_flows.md) |
| `EBASURA-M1-F6` | Supabase Auth Manager & User Session Provider | Active | `lib/auth/supabase_auth/supabase_auth_manager.dart` | [`identity_and_security.md`](identity_and_security.md) |

---

## 3. Submodule Directory

- **[`auth_flows.md`](auth_flows.md)**: Visual screens, form fields, validation logic, and routing transitions for registration, login, password recovery, landing page, and legal terms.
- **[`identity_and_security.md`](identity_and_security.md)**: Cryptographic session management, Supabase Auth Manager, token handling, email verification mechanisms, and role-based route gating.
