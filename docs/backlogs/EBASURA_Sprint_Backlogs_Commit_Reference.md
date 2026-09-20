# EBasura Sprint Backlogs — Commit Reference & Feature Catalog

This document is the canonical commit reference, feature catalog, and backlog tracking authority for the **EBasura** (AEBasura) mobile ecosystem.

---

## 1. Commit Code Grammar

All commits in the EBasura repository must adhere to Conventional Commits grammar and include the specialized system backlog code:

```text
<type>(<scope>): <concise description in past-tense> [EBASURA-M#-F#]

- <Past-tense change bullet>
- <Past-tense change bullet>
```

### Examples:
- `feat(gemini): integrated visual prompt injection guard for waste scans [EBASURA-M3-F4]`
- `fix(auth): handled invalid session refresh during app launch [EBASURA-M1-F6]`
- `docs(modules): compiled module 7 garbage collection schedules specifications [EBASURA-M7-F0]`
- `chore(deps): upgraded supabase_flutter package dependencies [EBASURA-M0-F0]`

### Valid Commit Types:
- `feat`: A new feature or user-facing capability.
- `fix`: A bug fix or patch for unexpected behavior.
- `docs`: Documentation-only updates.
- `refactor`: Code restructuring without functional changes.
- `test`: Adding or modifying automated unit/integration tests.
- `chore`: Routine maintenance, updating dependencies, or `.gitignore` tweaks.
- `ci`: CI/CD workflows, build pipelines, or test automations.
- `perf`: Performance optimizations (image compression, memory leaks).
- `style`: Code style/formatting adjustments without logic changes.
- `revert`: Reverting a previous commit.

---

## 2. Module Legend

| Module Code | Module Name | Primary Scope | Specification Directory |
| :--- | :--- | :--- | :--- |
| **M0** | Core Architecture, Setup & State Management | `core`, `deps`, `root` | [`../modules/module-0-core-architecture/README.md`](../modules/module-0-core-architecture/README.md) |
| **M1** | Authentication, Identity & Security | `auth` | [`../modules/module-1-auth-identity/README.md`](../modules/module-1-auth-identity/README.md) |
| **M2** | User Profile & Account Management | `profile` | [`../modules/module-2-profile-account/README.md`](../modules/module-2-profile-account/README.md) |
| **M3** | AI Waste Scanning & Classification (Gemini) | `gemini`, `waste-scan` | [`../modules/module-3-ai-waste-scanning/README.md`](../modules/module-3-ai-waste-scanning/README.md) |
| **M4** | Waste Records, Inspection & Moderation | `records`, `moderation` | [`../modules/module-4-image-records-moderation/README.md`](../modules/module-4-image-records-moderation/README.md) |
| **M5** | Gamification, Points System & Badges | `gamification`, `points`, `badges` | [`../modules/module-5-gamification-leaderboard/README.md`](../modules/module-5-gamification-leaderboard/README.md) |
| **M6** | Waste Reporting & Incident Alerts | `reports` | [`../modules/module-6-waste-reporting/README.md`](../modules/module-6-waste-reporting/README.md) |
| **M7** | Garbage Collection Schedules | `schedules` | [`../modules/module-7-collection-schedules/README.md`](../modules/module-7-collection-schedules/README.md) |
| **M8** | Street & Community Directory | `streets` | [`../modules/module-8-street-directory/README.md`](../modules/module-8-street-directory/README.md) |
| **M9** | Administrator Operations & User Management | `admin` | [`../modules/module-9-admin-operations/README.md`](../modules/module-9-admin-operations/README.md) |
| **M10** | Shared Navigation & Core Components | `nav`, `ui` | [`../modules/module-10-navigation-components/README.md`](../modules/module-10-navigation-components/README.md) |

---

## 3. Feature Code Index

### MODULE 0: Core Architecture, Setup & State Management (`EBASURA-M0-F#`)
- Specification: [`../modules/module-0-core-architecture/README.md`](../modules/module-0-core-architecture/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M0-F0` | Repository & Environment Governance | Setup, environment secret protection (`env.json`), developer skills | [`supabase_client_and_environment.md`](../modules/module-0-core-architecture/supabase_client_and_environment.md) |
| `EBASURA-M0-F1` | FlutterFlow Core Engine & Theme Provider | Theme tokens, responsive breakpoints, type-safe utilities | [`flutterflow_engine.md`](../modules/module-0-core-architecture/flutterflow_engine.md) |
| `EBASURA-M0-F2` | Supabase Client & Backend Infrastructure | Supabase client initialization, storage adapters, table schemas | [`supabase_client_and_environment.md`](../modules/module-0-core-architecture/supabase_client_and_environment.md) |
| `EBASURA-M0-F3` | Reactive App State Management | `AppStateNotifier` managing auth updates and splash presentation | [`flutterflow_engine.md`](../modules/module-0-core-architecture/flutterflow_engine.md) |

---

### MODULE 1: Authentication, Identity & Security (`EBASURA-M1-F#`)
- Specification: [`../modules/module-1-auth-identity/README.md`](../modules/module-1-auth-identity/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M1-F0` | Guest Landing Page & Gateway Entry | Entry screen with sign-in/up prompts and guest continuation | [`auth_flows.md`](../modules/module-1-auth-identity/auth_flows.md) |
| `EBASURA-M1-F1` | User Registration & Credential Validation | Sign-up form with email regex and password complexity validation | [`auth_flows.md`](../modules/module-1-auth-identity/auth_flows.md) |
| `EBASURA-M1-F2` | Email OTP Verification & Account Activation | 6-digit pin OTP confirmation screen activating new accounts | [`identity_and_security.md`](../modules/module-1-auth-identity/identity_and_security.md) |
| `EBASURA-M1-F3` | Authenticated Sign-In & Session Persistence | Email/password sign-in flow with session recovery | [`auth_flows.md`](../modules/module-1-auth-identity/auth_flows.md) |
| `EBASURA-M1-F4` | Password Recovery & Reset Flow | Forgot password email dispatch and credential reset | [`auth_flows.md`](../modules/module-1-auth-identity/auth_flows.md) |
| `EBASURA-M1-F5` | Terms and Conditions Acceptance | Legal terms, waste disposal rules, and consent acceptance | [`auth_flows.md`](../modules/module-1-auth-identity/auth_flows.md) |
| `EBASURA-M1-F6` | Supabase Auth Manager & User Session Provider | Low-level auth state stream and session listener | [`identity_and_security.md`](../modules/module-1-auth-identity/identity_and_security.md) |

---

### MODULE 2: User Profile & Account Management (`EBASURA-M2-F#`)
- Specification: [`../modules/module-2-profile-account/README.md`](../modules/module-2-profile-account/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M2-F0` | Profile Overview & Gamification Summary | Profile hub displaying points balance and unlocked badges | [`profile_management.md`](../modules/module-2-profile-account/profile_management.md) |
| `EBASURA-M2-F1` | Profile Details & Avatar Customization | Edit display name and upload new profile photo | [`profile_management.md`](../modules/module-2-profile-account/profile_management.md) |
| `EBASURA-M2-F2` | Email Address Modification Flow | Re-authentication and email address update flow | [`account_settings.md`](../modules/module-2-profile-account/account_settings.md) |
| `EBASURA-M2-F3` | Security Password Modification Flow | Password rotation with validation and confirmation | [`account_settings.md`](../modules/module-2-profile-account/account_settings.md) |
| `EBASURA-M2-F4` | Account Settings & Preference Toggles | Push notification switches and session logout | [`account_settings.md`](../modules/module-2-profile-account/account_settings.md) |
| `EBASURA-M2-F5` | Informational & Research "About" Views | About EBasura, ADET course info, and AI research documentation | [`profile_management.md`](../modules/module-2-profile-account/profile_management.md) |

---

### MODULE 3: AI Waste Scanning & Classification (`EBASURA-M3-F#`)
- Specification: [`../modules/module-3-ai-waste-scanning/README.md`](../modules/module-3-ai-waste-scanning/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M3-F0` | Gemini REST Client & Payload Serializer | Base64 image payload construction and REST HTTP client | [`gemini_api_integration.md`](../modules/module-3-ai-waste-scanning/gemini_api_integration.md) |
| `EBASURA-M3-F1` | Authenticated User Waste Scanner | Camera/gallery image capture and classification for users | [`gemini_api_integration.md`](../modules/module-3-ai-waste-scanning/gemini_api_integration.md) |
| `EBASURA-M3-F2` | Guest Waste Scanner Flow | Lightweight guest scanner without persistent DB records | [`gemini_api_integration.md`](../modules/module-3-ai-waste-scanning/gemini_api_integration.md) |
| `EBASURA-M3-F3` | 5-Attribute Classification Evaluator | Parsing valid_waste, recyclable, segregated, biodegradable | [`classification_and_injection_guard.md`](../modules/module-3-ai-waste-scanning/classification_and_injection_guard.md) |
| `EBASURA-M3-F4` | Visual Prompt Injection Guard | Adversarial text prompt injection detection and override | [`classification_and_injection_guard.md`](../modules/module-3-ai-waste-scanning/classification_and_injection_guard.md) |
| `EBASURA-M3-F5` | Scan Revalidation & Dev Pipeline | Secondary verification endpoint and development prompt sandbox | [`gemini_api_integration.md`](../modules/module-3-ai-waste-scanning/gemini_api_integration.md) |

---

### MODULE 4: Waste Image Records, Inspection & Moderation (`EBASURA-M4-F#`)
- Specification: [`../modules/module-4-image-records-moderation/README.md`](../modules/module-4-image-records-moderation/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M4-F0` | User Personal Upload History | Paginated personal scan history feed ("My Uploads") | [`image_views_and_history.md`](../modules/module-4-image-records-moderation/image_views_and_history.md) |
| `EBASURA-M4-F1` | Public Waste Feed & Gallery | Community gallery of public verified waste submissions | [`image_views_and_history.md`](../modules/module-4-image-records-moderation/image_views_and_history.md) |
| `EBASURA-M4-F2` | Verifier Inspection & Audit View | Full-resolution inspector view with AI attribute breakdown | [`image_views_and_history.md`](../modules/module-4-image-records-moderation/image_views_and_history.md) |
| `EBASURA-M4-F3` | Category Filter Hub & Feeds | Filtered feeds (AI, segregated, unsegregated, verified) | [`image_filtering_and_moderation.md`](../modules/module-4-image-records-moderation/image_filtering_and_moderation.md) |
| `EBASURA-M4-F4` | Flagged & Suspicious Waste Moderation | Review queue for quarantined prompt injection or invalid uploads | [`image_filtering_and_moderation.md`](../modules/module-4-image-records-moderation/image_filtering_and_moderation.md) |
| `EBASURA-M4-F5` | Image Record Deletion & Cleanup | Image asset and database record deletion with point rollback | [`image_filtering_and_moderation.md`](../modules/module-4-image-records-moderation/image_filtering_and_moderation.md) |
| `EBASURA-M4-F6` | Image Informational Dialogs | Educational modal explaining waste attribute classifications | [`image_views_and_history.md`](../modules/module-4-image-records-moderation/image_views_and_history.md) |

---

### MODULE 5: Gamification, Points System & Badges (`EBASURA-M5-F#`)
- Specification: [`../modules/module-5-gamification-leaderboard/README.md`](../modules/module-5-gamification-leaderboard/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M5-F0` | Community Leaderboard Ranking | Real-time community leaderboard podium and ranked member list | [`points_and_leaderboard.md`](../modules/module-5-gamification-leaderboard/points_and_leaderboard.md) |
| `EBASURA-M5-F1` | Points Engine & Ledger Calculation | Point awarding rules for valid scans, segregation, and reports | [`points_and_leaderboard.md`](../modules/module-5-gamification-leaderboard/points_and_leaderboard.md) |
| `EBASURA-M5-F2` | Badge Milestone Evaluation & Unlock | Milestone point evaluation unlocking achievement badges | [`badges_and_achievements.md`](../modules/module-5-gamification-leaderboard/badges_and_achievements.md) |
| `EBASURA-M5-F3` | User Badge Showcase & Details | Showcase card displaying badge criteria and date unlocked | [`badges_and_achievements.md`](../modules/module-5-gamification-leaderboard/badges_and_achievements.md) |
| `EBASURA-M5-F4` | Public Badge Directory View | Catalog view of all available badges with locked/unlocked state | [`badges_and_achievements.md`](../modules/module-5-gamification-leaderboard/badges_and_achievements.md) |

---

### MODULE 6: Waste Reporting & Community Alerts (`EBASURA-M6-F#`)
- Specification: [`../modules/module-6-waste-reporting/README.md`](../modules/module-6-waste-reporting/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M6-F0` | Community Waste Incident Submission | Reporting form with date, description, and street selection | [`incident_reporting.md`](../modules/module-6-waste-reporting/incident_reporting.md) |
| `EBASURA-M6-F1` | Reports Directory & Feed | Community feed of active waste reports with status indicators | [`report_management.md`](../modules/module-6-waste-reporting/report_management.md) |
| `EBASURA-M6-F2` | Single Report Details & Location Inspection | Detailed incident view with street information and timestamp | [`report_management.md`](../modules/module-6-waste-reporting/report_management.md) |
| `EBASURA-M6-F3` | Incident Attached Photos Viewer | Full-screen photo evidence viewer with zoom and swipe carousel | [`incident_reporting.md`](../modules/module-6-waste-reporting/incident_reporting.md) |
| `EBASURA-M6-F4` | Incident Report Deletion & Resolution | Resolution flow and administrative incident report deletion | [`report_management.md`](../modules/module-6-waste-reporting/report_management.md) |

---

### MODULE 7: Garbage Collection Schedules (`EBASURA-M7-F#`)
- Specification: [`../modules/module-7-collection-schedules/README.md`](../modules/module-7-collection-schedules/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M7-F0` | Community Collection Timetable Directory | Chronological collection calendar with street filtering | [`schedule_directory.md`](../modules/module-7-collection-schedules/schedule_directory.md) |
| `EBASURA-M7-F1` | Single Schedule Detail Inspection | Detail card with pickup time window, route, and collector | [`schedule_directory.md`](../modules/module-7-collection-schedules/schedule_directory.md) |
| `EBASURA-M7-F2` | Admin Collection Schedule Authoring | Schedule creation modal with date, time, and collector fields | [`schedule_management.md`](../modules/module-7-collection-schedules/schedule_management.md) |
| `EBASURA-M7-F3` | Collection Schedule Deletion & Cancellation | Schedule cancellation and removal modal | [`schedule_management.md`](../modules/module-7-collection-schedules/schedule_management.md) |
| `EBASURA-M7-F4` | Collection Table Schema & Relations | Postgres `collection` table data schema and relational mapping | [`schedule_management.md`](../modules/module-7-collection-schedules/schedule_management.md) |

---

### MODULE 8: Street & Community Directory (`EBASURA-M8-F#`)
- Specification: [`../modules/module-8-street-directory/README.md`](../modules/module-8-street-directory/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M8-F0` | Community Street Index Directory | Directory of registered community streets with search filter | [`street_registry.md`](../modules/module-8-street-directory/street_registry.md) |
| `EBASURA-M8-F1` | Street Profile & Schedule Summary | Street profile linking upcoming pickups and recent waste reports | [`street_registry.md`](../modules/module-8-street-directory/street_registry.md) |
| `EBASURA-M8-F2` | Admin Street Registration Flow | Modal form to register new community streets | [`street_management.md`](../modules/module-8-street-directory/street_management.md) |
| `EBASURA-M8-F3` | Street Deletion & Cascade Safety | Safeguarded street removal with dependency warnings | [`street_management.md`](../modules/module-8-street-directory/street_management.md) |
| `EBASURA-M8-F4` | Street Table Schema & Relations | Postgres `street` table definition and foreign key relations | [`street_management.md`](../modules/module-8-street-directory/street_management.md) |

---

### MODULE 9: Administrator Operations & User Management (`EBASURA-M9-F#`)
- Specification: [`../modules/module-9-admin-operations/README.md`](../modules/module-9-admin-operations/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M9-F0` | Central Admin Operations Dashboard | Command center showing platform metrics and quick action links | [`admin_dashboard.md`](../modules/module-9-admin-operations/admin_dashboard.md) |
| `EBASURA-M9-F1` | User Management Console & Auditing | Registered user table with search, role badges, and points review | [`user_management.md`](../modules/module-9-admin-operations/user_management.md) |
| `EBASURA-M9-F2` | User Role Assignment & Suspension | Administrative elevation to admin or suspension of abusive users | [`user_management.md`](../modules/module-9-admin-operations/user_management.md) |
| `EBASURA-M9-F3` | Admin Badge Authoring & Asset Upload | Authoring modal to create new badges and upload vector/PNG assets | [`badge_administration.md`](../modules/module-9-admin-operations/badge_administration.md) |
| `EBASURA-M9-F4` | Badge Revocation & Deletion | Deletion modal for obsolete achievement badges | [`badge_administration.md`](../modules/module-9-admin-operations/badge_administration.md) |
| `EBASURA-M9-F5` | Flagged & Prompt Injection Queue Review | Quarantined moderation queue for adversarial or invalid uploads | [`admin_dashboard.md`](../modules/module-9-admin-operations/admin_dashboard.md) |

---

### MODULE 10: Navigation & Shared Components (`EBASURA-M10-F#`)
- Specification: [`../modules/module-10-navigation-components/README.md`](../modules/module-10-navigation-components/README.md)

| Commit Code | Feature Name | Description | Specification Link |
| :--- | :--- | :--- | :--- |
| `EBASURA-M10-F0` | GoRouter Route Table & Interceptors | Declarative routing table, auth intercepts, and parameter parsing | [`routing_and_navigation.md`](../modules/module-10-navigation-components/routing_and_navigation.md) |
| `EBASURA-M10-F1` | Homepage Hub & Quick Action Grid | Central user home screen with quick-action tiles and community stats | [`routing_and_navigation.md`](../modules/module-10-navigation-components/routing_and_navigation.md) |
| `EBASURA-M10-F2` | Sub-Features Discovery Directory | Categorized hub for secondary features and documentation screens | [`routing_and_navigation.md`](../modules/module-10-navigation-components/routing_and_navigation.md) |
| `EBASURA-M10-F3` | Bottom Navigation Bar | Persistent bottom bar with route awareness and tab highlighting | [`shared_ui_components.md`](../modules/module-10-navigation-components/shared_ui_components.md) |
| `EBASURA-M10-F4` | Maintenance Banner & Modal Templates | Broadcast notification banners, maintenance alerts, and dialog shells | [`shared_ui_components.md`](../modules/module-10-navigation-components/shared_ui_components.md) |
