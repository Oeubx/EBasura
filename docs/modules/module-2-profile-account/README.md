# Module 2: User Profile & Account Management

## 1. Overview
Module 2 manages authenticated user account self-service, profile configuration, credentials updating (email/password), personalized settings, and static informational pages describing the application and its underlying research.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M2-F0` | Profile Overview & Gamification Summary | Active | `lib/profile/page_profile/` | [`profile_management.md`](profile_management.md) |
| `EBASURA-M2-F1` | Profile Details & Avatar Customization | Active | `lib/profile/page_change_profile/` | [`profile_management.md`](profile_management.md) |
| `EBASURA-M2-F2` | Email Address Modification Flow | Active | `lib/profile/page_change_email/` | [`account_settings.md`](account_settings.md) |
| `EBASURA-M2-F3` | Security Password Modification Flow | Active | `lib/profile/page_change_password/` | [`account_settings.md`](account_settings.md) |
| `EBASURA-M2-F4` | Account Settings & Preference Toggles | Active | `lib/profile/page_profile_settings/` | [`account_settings.md`](account_settings.md) |
| `EBASURA-M2-F5` | Informational & Research "About" Views | Active | `lib/profile/abouts/` | [`profile_management.md`](profile_management.md) |

---

## 3. Submodule Directory

- **[`account_settings.md`](account_settings.md)**: Specifications for changing credentials, managing active notification preferences, and navigating account security settings.
- **[`profile_management.md`](profile_management.md)**: Specifications for display name and avatar updates, gamification badge highlights on profile, and project research/about views.
- **[`optimizations.md`](optimizations.md)**: Architectural modernization specifications, milestone progression visualizers, and client-side avatar image compression.
