# CRUD & Action Permissions Matrix

## 1. Overview & Action Taxonomy

This document provides an exhaustive, operation-level **CRUD (Create, Read, Update, Delete) + USE** permissions matrix across all 8 functional domains of the EBasura platform for each user tier:
- **Guest** (`UserRole.guest`): Anonymous or unauthenticated sessions.
- **Resident** (`UserRole.resident`): Verified community members with active accounts.
- **Collection Crew** (`UserRole.crew`): Waste collection field personnel.
- **Administrator** (`UserRole.admin`): Barangay officials and platform moderators.

### Action Taxonomy
- **USE**: Execute interactive client-side operations or real-time AI inferences without necessarily writing records to the database (e.g., stateless camera inference, shift status toggling).
- **C (Create)**: Upload and persist new records in Supabase tables and storage buckets (`INSERT`).
- **R (Read)**: Query, view, and inspect existing records and feeds (`SELECT`).
- **U (Update)**: Mutate existing records, status flags, points, or verification decisions (`UPDATE`).
- **D (Delete)**: Permanently remove or cancel records and assets (`DELETE`).

---

## 2. Executive Master CRUD Matrix

The master table below summarizes permissions across all 8 platform modules at a glance:

| Module / Domain | User Tier | USE | C (Create) | R (Read) | U (Update) | D (Delete) | Summary Scope & Boundaries |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **1. AI Waste Scanning & Image Records** | **Guest** | ✅ | ✅ | ❌ | ❌ | ❌ | Gemini vision scan; anonymous persistence to `Image_Bucket/Guest/` and `Image` table (0 pts). |
| | **Resident** | ✅ | ✅ | ✅ | ✅ | ✅ | Full scan, upload, own photo history, dispute/flag. |
| | **Crew** | ✅ | ✅ | ✅ | ✅ | ✅ | On-field scan, upload, own photo history, dispute. |
| | **Admin** | ✅ | ✅ | ✅ | ✅ | ✅ | Full scan, full moderation, override, delete any. |
| **2. Waste Incident Reports** | **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Read-only public audit summaries; cannot report. |
| | **Resident** | ❌ | ✅ | ✅ | ❌ | ❌ | File reports with photos; track own resolution. |
| | **Crew** | ❌ | ✅ | ✅ | ✅ | ❌ | File reports on route; mark in-progress. |
| | **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Full resolution lifecycle, add action notes, delete. |
| **3. Collection Schedules** | **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Read upcoming pickup dates and times per street. |
| | **Resident** | ❌ | ❌ | ✅ | ❌ | ❌ | Read upcoming pickup dates; filter by street. |
| | **Crew** | ✅ | ❌ | ✅ | ✅ | ❌ | Read pickup dates; toggle street collection checklist. |
| | **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Full CRUD: author, update hours, delete schedules. |
| **4. Community Leaderboard & Points** | **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Read-only rankings podium; cannot earn points. |
| | **Resident** | ❌ | ❌ | ✅ | ❌ | ❌ | Ranked participant; auto-accumulate points in `points_ledger` via server triggers; configure name privacy (`full_name`, `initials`, `anonymous`). |
| | **Crew** | ❌ | ❌ | ✅ | ❌ | ❌ | View periodic and collaborative street rankings. |
| | **Admin** | ❌ | ❌ | ✅ | ✅ | ❌ | View master rankings; audit ledger awards and reversals. |
| **5. Street Directory & Compliance Desk** | **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Read registered streets and public compliance snapshots. |
| | **Resident** | ❌ | ❌ | ✅ | ❌ | ❌ | Read street schedules, street compliance grade, and anonymous tips. |
| | **Crew** | ❌ | ❌ | ✅ | ❌ | ❌ | Read routes; inspect spot-check markers on flagged streets. |
| | **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Full CRUD: manage streets, recompute SCI snapshots, execute flag interventions (`open` $\to$ `notified` $\to$ `in_followup` $\to$ `resolved`). |
| **6. Badges & Rewards** | **Guest** | ❌ | ❌ | ❌ | ❌ | ❌ | Gated; badges require authenticated profile. |
| | **Resident** | ❌ | ❌ | ✅ | ✅ | ❌ | View earned vs locked badges; dismiss celebration modal (`UPDATE seen_at`); track weekly streaks and monthly freeze. |
| | **Crew** | ❌ | ❌ | ✅ | ❌ | ❌ | View earned badges on profile. |
| | **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Full CRUD: author rule-based badges (points, segregation, recycling, reports, streaks), revoke/delete. |
| **7. User Management & Profiles** | **Guest** | ❌ | ✅ | ❌ | ❌ | ❌ | Create new account via registration (`PageSignUp`). |
| | **Resident** | ❌ | ❌ | ✅ | ✅ | ✅ | View/edit own profile, password; delete account. |
| | **Crew** | ❌ | ❌ | ✅ | ✅ | ❌ | View/edit own credentials and phone number. |
| | **Admin** | ❌ | ❌ | ✅ | ✅ | ✅ | Full user console: elevate roles, suspend, edit pts. |
| **8. Crew Dispatch & Route Tracking** | **Guest** | ❌ | ❌ | ❌ | ❌ | ❌ | No access; restricted to collection crew/admin. |
| | **Resident** | ❌ | ❌ | ❌ | ❌ | ❌ | No access; restricted to collection crew/admin. |
| | **Crew** | ✅ | ❌ | ✅ | ✅ | ❌ | Toggle shift status; mark street pickup checklist. |
| | **Admin** | ❌ | ❌ | ✅ | ❌ | ❌ | View crew route progress and completion metrics. |

---

## 3. Detailed Per-Module Breakdown

### 3.1 Module 1: AI Waste Scanning & Image Records

* **Target Supabase Tables**: `Image`, `user`, `user_subtable`  
* **Storage Bucket**: `Image_Bucket` (`Image_Bucket/{street}/`, `Image_Bucket/Guest/`)  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ✅ | ✅ | ❌ | ❌ | ❌ | Center Camera FAB $\to$ `PImgUploadAGuestWidget` | Executes Gemini vision call; uploads photo to `Image_Bucket/Guest/`; inserts `Image` record (`img_uploader: null`, `status: 'Non-Verified'`); awards 0 points to protect leaderboard integrity. |
| **Resident** | ✅ | ✅ | ✅ | ✅ | ✅ | Center Camera FAB $\to$ `PImgUploadAAuthWidget`<br/>Profile $\to$ `PImagesViewAllUserWidget`<br/>`CDisputeDecisionWidget` | **USE/C**: Uploads photo to `Image_Bucket/{street}/`, inserts `Image` record (`status = 'Non-Verified'`), awards points.<br/>**R**: Queries `Image` where `img_uploader == currentUser.uid`.<br/>**U**: Submits dispute/flag (`allowFlagging == true`) to appeal wrong AI/verifier decisions.<br/>**D**: Deletes personal scan record via `c_image_deletion`. |
| **Crew** | ✅ | ✅ | ✅ | ✅ | ✅ | Center Camera FAB $\to$ `PImgUploadAAuthWidget`<br/>Profile $\to$ `PImagesViewAllUserWidget` | **USE/C**: On-field waste scanning.<br/>**R/U/D**: Operates on own uploaded records; can dispute misclassifications. |
| **Admin** | ✅ | ✅ | ✅ | ✅ | ✅ | Tab 2: Review $\to$ `PImagesViewAllWidget`<br/>`PImgViewVerifierWidget`<br/>`PageFilteredImagesWidget` | **USE/C**: Official calibration scans.<br/>**R**: Unrestricted `SELECT` on all community records.<br/>**U**: Verifies scans, overrides AI categories, confirms flags, awards/deducts points.<br/>**D**: Purges invalid, offensive, or duplicate community images. |

---

### 3.2 Module 2: Waste Incident Reports

* **Target Supabase Table**: `Report`  
* **Storage Bucket**: `Image_Bucket/Reports/`  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Explore $\to$ `PageViewSubFeaturesWidget`<br/>`PReportViewOneWidget` | **R**: Read-only public audit summaries and resolved community reports. Cannot submit or mutate. |
| **Resident** | ❌ | ✅ | ✅ | ❌ | ❌ | Profile $\to$ "Report Waste Incident"<br/>`PageProfileWidget`<br/>`PReportViewAllWidget` | **C**: Submits new incident with subject, photo (`Image_Bucket/Reports/`), street dropdown, and description (`report_status = 'Pending'`).<br/>**R**: Reads community report feed and tracks personal report resolution status. |
| **Crew** | ❌ | ✅ | ✅ | ✅ | ❌ | Bottom Bar $\to$ "Reports"<br/>`PReportViewAllWidget`<br/>`CReportCreationWidget` | **C**: Files roadside overflow or missed pickup incident while en route.<br/>**R**: Monitors route reports.<br/>**U**: Can flag incident as `'In Progress'` upon reaching site. |
| **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Admin Dashboard $\to$ "Waste Reports"<br/>`PReportViewOneWidget`<br/>`PReportViewAllWidget` | **C**: Files official municipal waste audit reports.<br/>**R**: Inspects full report queue.<br/>**U**: Changes status (`Pending` $\to$ `In Progress` $\to$ `Resolved`) with action notes.<br/>**D**: Deletes false or duplicate incident complaints. |

---

### 3.3 Module 3: Collection Schedules

* **Target Supabase Table**: `collection`  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Home $\to$ "Upcoming Collection"<br/>`PDatesViewAllWidget`, `PDatesViewOneWidget` | **R**: Queries all active collection schedules; inspects dates, times, and street coverage. |
| **Resident** | ❌ | ❌ | ✅ | ❌ | ❌ | Home $\to$ Collection Banner<br/>`PDatesViewAllWidget`, `PDatesViewOneWidget` | **R**: Queries schedules; auto-filtered or highlighted for resident's registered street. |
| **Crew** | ✅ | ❌ | ✅ | ✅ | ❌ | Tab 1: Routes $\to$ `PageCrewDashboardWidget`<br/>Tab 2: Pickups $\to$ `PDatesViewAllWidget` | **USE/U**: Checks off collected streets during active shift (`_collectedStreetIds`).<br/>**R**: Views assigned daily pickup routes. |
| **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Admin Dashboard $\to$ "Collection Dates"<br/>`c_dates_creation`, `c_dates_update`, `c_dates_deletion` | **C**: Creates new pickup schedule (`INSERT into collection`).<br/>**R**: Master schedule calendar.<br/>**U**: Edits pickup time range, truck crew, notes.<br/>**D**: Cancels and deletes schedule row (`DELETE`). |

---

### 3.4 Module 4: Community Leaderboard & Points

* **Target Supabase Tables**: `points_ledger`, `"User Subtable"`, `"User"`  
* **Stored Procedures / RPCs**: `get_leaderboard(p_period, p_limit)`, `get_street_leaderboard(p_period)`, `get_my_rank(p_period)`  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Tab 2: Rankings $\to$ `PageLeaderboardWidget` | **R**: Queries Top 3 podium and ranked community list via RPC. Guest has no points profile. |
| **Resident** | ❌ | ❌ | ✅ | ❌ | ❌ | Tab 2: Rankings $\to$ `PageLeaderboardWidget`<br/>Profile points pill<br/>Settings $\to$ Privacy Sheet | **R**: Queries personal ranking, deficit standing, and periodic boards.<br/>*RLS*: Resident can `SELECT` own `points_ledger` records (`user_id = auth.uid()`). All point credits/debits are server-enforced by database triggers (`trg_image_points`, `trg_sync_user_points`). Can update own `leaderboard_privacy_mode` (`full_name`, `initials`, `anonymous`). |
| **Crew** | ❌ | ❌ | ✅ | ❌ | ❌ | Explore $\to$ `PageLeaderboardWidget` | **R**: Inspects periodic and collaborative streets leaderboards. |
| **Admin** | ❌ | ❌ | ✅ | ✅ | ❌ | Admin Dashboard $\to$ "User Management"<br/>`PageUserManagementWidget` | **R**: Full audit of `points_ledger` entries and daily award caps.<br/>**U**: Administrative point adjustments with audit justification notes. |

---

### 3.5 Module 5: Street Directory & Compliance Desk

* **Target Supabase Tables**: `Street`, `street_compliance_snapshot`, `street_flag`  
* **Stored Procedures / RPCs**: `fn_compute_street_compliance(p_target_week)`  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ❌ | ✅ | ❌ | ❌ | Explore $\to$ `PStreetViewOneWidget` | **R**: Lookup street names, zones, collection schedules, and public SCI snapshots. |
| **Resident** | ❌ | ❌ | ✅ | ❌ | ❌ | Home $\to$ Street Cleanliness Card<br/>`PageHomepageWidget` | **R**: Views registered street 4-week rolling cleanliness grade (A–D). For Grade C/D streets, reads anonymous educational advisory tips. |
| **Crew** | ❌ | ❌ | ✅ | ❌ | ❌ | Crew Checklist $\to$ `PageCrewDashboardWidget` | **R**: Reads route collection checklist with automated red spot-check warning markers on flagged streets (`status != 'resolved'`). |
| **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Admin Dashboard $\to$ "Street Compliance Desk"<br/>`PStreetComplianceDeskWidget`<br/>`c_street_creation`, `c_street_deletion` | **C**: Registers streets; manual recomputation trigger.<br/>**R**: Full street directory, historical SCI snapshots, and flag queue.<br/>**U**: Advances flag lifecycle (`open` $\to$ `notified` $\to$ `in_followup` $\to$ `resolved`) and writes intervention audit notes.<br/>**D**: Deletes retired streets from directory. |

---

### 3.6 Module 6: Badges & Rewards

* **Target Supabase Tables**: `Badge`, `user_badge_junction`, `"User Subtable"`  
* **Stored Procedures / RPCs**: `fn_evaluate_badges(p_user_id)`, `get_my_unlocked_badges()`, `mark_badge_seen(p_badge_id)`  
* **Storage Bucket**: `Image_Bucket/Badges/`  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ❌ | ❌ | ❌ | ❌ | Not Available | Badges are tied to authenticated profile achievements. |
| **Resident** | ❌ | ❌ | ✅ | ✅ | ❌ | Tab 4: Profile $\to$ Badge Shelf & Streak<br/>`CBadgeCelebrationWidget` | **R**: Queries unlocked badges from `user_badge_junction` joined with `Badge`. Reads weekly streak (`🔥 X Weeks`) and monthly freeze status.<br/>**U**: Dismisses celebratory unlock dialog, updating `seen_at = now()` on owned junction record. |
| **Crew** | ❌ | ❌ | ✅ | ❌ | ❌ | Profile $\to$ Badge Showcase | **R**: Views earned badges on personal profile. |
| **Admin** | ❌ | ✅ | ✅ | ✅ | ✅ | Admin Dashboard $\to$ "Badges"<br/>`PBadgeViewAllWidget`<br/>`CBadgesCreationWidget` | **C**: Authors new badge with rule type (`points`, `segregated_count`, `recyclable_count`, `report_count`, `streak`), threshold, and PNG icon.<br/>**R**: Master badge directory.<br/>**U**: Modifies unlock rules and thresholds.<br/>**D**: Deletes or revokes achievement badges. |

---

### 3.7 Module 7: User Management & Profiles

* **Target Supabase Table**: `user`  
* **Storage Bucket**: `avatars/`  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ✅ | ❌ | ❌ | ❌ | Landing $\to$ `PageSignUpWidget` | **C**: Registers new account with email, display name, street, and password. |
| **Resident** | ❌ | ❌ | ✅ | ✅ | ✅ | Tab 4: Profile $\to$ `PageProfileSettingsWidget`<br/>`PageChangeProfileWidget`, `PageChangeEmailWidget`, `PageChangePasswordWidget` | **R**: Inspects own user profile data.<br/>**U**: Edits display name, avatar photo, email (via OTP), and password.<br/>**D**: Deletes personal account and clears local session. |
| **Crew** | ❌ | ❌ | ✅ | ✅ | ❌ | Profile $\to$ `PageProfileSettingsWidget` | **R**: Inspects crew account details.<br/>**U**: Updates contact number and password. |
| **Admin** | ❌ | ❌ | ✅ | ✅ | ✅ | Tab 4: Users $\to$ `PageUserManagementWidget` | **R**: Searches and audits all registered users.<br/>**U**: Elevates/demotes roles (`resident` $\leftrightarrow$ `crew` $\leftrightarrow$ `admin`), suspends accounts.<br/>**D**: Soft-deletes or purges fraudulent user accounts. |

---

### 3.8 Module 8: Crew Dispatch & Route Tracking

* **Target Supabase Tables**: `collection` (shift status, checklist state)  

| User Tier | USE | C | R | U | D | UI Trigger / Component | Technical Operation Details |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **Guest** | ❌ | ❌ | ❌ | ❌ | ❌ | Not Available | Route dispatch is restricted to collection crew and administrators. |
| **Resident** | ❌ | ❌ | ❌ | ❌ | ❌ | Not Available | Restricted to collection crew and administrators. |
| **Crew** | ✅ | ❌ | ✅ | ✅ | ❌ | Tab 1: Routes $\to$ `PageCrewDashboardWidget` | **USE/U**: Switches active shift status (*Idle*, *En Route*, *In Progress*, *Completed*); marks collection checklist.<br/>**R**: Queries daily assigned route schedule. |
| **Admin** | ❌ | ❌ | ✅ | ❌ | ❌ | Admin Dashboard $\to$ Operational Metrics | **R**: Inspects real-time street collection completion progress. |

---

## 4. Verification & Testing Runbook

For hands-on step-by-step verification of these permissions and features in the running mobile application, refer to the following companion guides:

- 📋 **[`qa_verification_checklist.md`](qa_verification_checklist.md)**: 45 interactive self-verification check items covering all four roles, UI screen inventories, interactive controls, and Supabase SQL queries for role switching.
- 📖 **[`guest_access.md`](guest_access.md)**: Deep dive into Guest visual screens, controls, and unauthenticated flows.
- 📖 **[`resident_access.md`](resident_access.md)**: Deep dive into Resident features, points, uploads archive, and dispute flows.
- 📖 **[`crew_access.md`](crew_access.md)**: Deep dive into Crew dispatch dashboards, shift status, and route checklists.
- 📖 **[`admin_access.md`](admin_access.md)**: Deep dive into Admin command hub, verifier overrides, user management, and schedule authoring.

