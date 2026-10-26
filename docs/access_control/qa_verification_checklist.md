# EBasura Access Control QA Self-Verification Runbook & Checklist

## 1. Overview & Purpose

This document is a hands-on, testable **Quality Assurance (QA) Runbook** designed to enable developers, product owners, and community testers to verify that all access permissions, role gates, visual controls, and navigation flows in EBasura are correctly applied and operational.

Each test section includes:
- **Visual Inventory ("What to See")**: Expected screen elements upon arrival.
- **Interactive Action ("What to Do / Tap")**: Specific gesture or click trigger.
- **Expected Outcome**: What the application should do or display.
- **Pass/Fail Checkbox**: `[ ]` for manual test tracking.

---

## 2. Test Environment Setup & Role Switching Guide

To test all four user tiers (**Guest**, **Resident**, **Collection Crew**, **Administrator**) using a single test device or simulator, follow this role switching procedure in Supabase:

### How to Switch Roles in Supabase:
1. Open your **Supabase Dashboard** $\to$ Select your EBasura project $\to$ Navigate to the **Table Editor**.
2. Select the **`user`** table.
3. Locate your test account row by filtering by `email` or `user_id`.
4. Modify the **`user_type`** column value:
   - For **Guest**: Sign out in the app (or clear app data / use an unauthenticated session).
   - For **Resident**: Set `user_type` = `'resident'` (or `'user'`).
   - For **Collection Crew**: Set `user_type` = `'crew'`.
   - For **Administrator**: Set `user_type` = `'admin'`.
5. In the mobile app:
   - Either navigate between tabs (which re-evaluates `RoleService.fetchCurrentUserRole()`), or **fully close and relaunch the app** to force a fresh role bootstrap.

---

## 3. Test Suite 1: Guest Role Verification (`UserRole.guest`)

| Status | Verification Item | Target Screen / UI Element | Action to Perform | Expected Behavior |
| :---: | :--- | :--- | :--- | :--- |
| [ ] | **G-01** | `LandingPageWidget` (`/landingPage`) | Launch fresh app or sign out | Displays welcome screen with "Sign Up", "Sign In", and "Continue as Guest" buttons. |
| [ ] | **G-02** | Gateway Navigation | Tap "Continue as Guest" | Transitions to Homepage (`PageHomepageWidget`) in Guest mode without requiring credentials. |
| [ ] | **G-03** | Guest Bottom Navigation Bar | `CBottomBarWidget` | Inspect bottom bar items | Displays exactly 4 tabs + 1 Center FAB:<br/>`[ 🏠 Home ] [ 🏆 Rankings ] [ 📷 Camera ] [ 🧭 Explore ] [ 🔑 Sign In ]`. Notice Tab 5 is **"Sign In"** (NOT Profile). |
| [ ] | **G-04** | Guest Header Identity | Top of `PageHomepageWidget` | Inspect header text | Displays *"Hello, Eco Explorer"* (no personal user name). |
| [ ] | **G-05** | Guest Promotional Banner | Upper card on `PageHomepageWidget` | Inspect hero banner | Displays promotional banner prompting the user to create an account to earn verified points. |
| [ ] | **G-06** | Guest AI Waste Scanner | Tap Center Camera FAB (or Home "Scan Waste" card) | Point camera at waste item and take photo | Opens `PImgUploadAGuestWidget`. Camera viewfinder triggers. Gemini AI analyzes image. Returns material type & segregation instructions. |
| [ ] | **G-07** | Guest Cloud Persistence & Safeguards | Post-scan screen in `PImgUploadAGuestWidget` | Check points and Supabase | **No points are credited (0 pts)**. Image is uploaded to `Image_Bucket/Guest/`. Row is inserted into Supabase `Image` table with `img_uploader: null` and `status = 'Non-Verified'`. Guest Participation Mode card renders cleanly. |
| [ ] | **G-08** | Read-Only Collection Schedule | Scroll to "Upcoming Collection" card on Home $\to$ Tap card or "View All" | Inspect schedule list | Opens `PDatesViewAllWidget`. Guest can view all upcoming pickup dates and tap a card to view pickup hours in `PDatesViewOneWidget`. |
| [ ] | **G-09** | Read-Only Leaderboard | Tap Tab 2 ("Rankings") on bottom bar | Inspect leaderboard screen | Opens `PageLeaderboardWidget`. Guest can view top 3 podium and community ranking list. A persistent bottom card prompts: *"Sign In to join the leaderboard"*. |
| [ ] | **G-10** | Explore Sub-Features | Tap Tab 4 ("Explore") on bottom bar | Switch between Collections and Reports sub-tabs | Opens `PageViewSubFeaturesWidget`. Displays public collection dates and completed community waste audits (`_buildReportCard`). |
| [ ] | **G-11** | Sign In Conversion Tab | Tap Tab 5 ("Sign In") on bottom bar | Tap icon | Navigates directly back to `LandingPageWidget` / `PageSignInWidget`. |

---

## 4. Test Suite 2: Resident Role Verification (`UserRole.resident`)

| Status | Verification Item | Target Screen / UI Element | Action to Perform | Expected Behavior |
| :---: | :--- | :--- | :--- | :--- |
| [ ] | **R-01** | Resident Authentication | `PageSignInWidget` (`/pageSignIn`) | Enter resident email and password $\to$ tap "Sign In" | Authenticates user, restores session, and redirects to `PageHomepageWidget`. |
| [ ] | **R-02** | Resident Bottom Bar | `CBottomBarWidget` | Inspect bottom bar tabs | Displays exactly 4 tabs + 1 Center FAB:<br/>`[ 🏠 Home ] [ 🏆 Rankings ] [ 📷 Camera ] [ 🧭 Explore ] [ 👤 Profile ]`. Notice Tab 5 is **"Profile"** (avatar icon). |
| [ ] | **R-03** | Resident Personal Header | Top of `PageHomepageWidget` | Inspect header and rank pill | Displays *"Hello, [Your Display Name]"*. Top-right displays an interactive **Points & Rank Badge Pill**. |
| [ ] | **R-04** | Rank Pill Quick Jump | Tap the Points & Rank badge pill | Tap pill | Immediately navigates to `PageLeaderboardWidget` with your rank highlighted. |
| [ ] | **R-05** | Authenticated AI Scanner | Tap Center Camera FAB | Capture photo of recyclable item | Launches `PImgUploadAAuthWidget` with `autoTriggerCamera: true`. Camera automatically opens. Captures photo $\to$ uploads to Supabase `Image_Bucket/{street}/` $\to$ Gemini classifies item $\to$ awards eco-points (e.g. `+25 pts`) $\to$ inserts row into `Image` table (`status = 'Non-Verified'`). |
| [ ] | **R-06** | Points & Streak Update | Return to Home post-scan | Inspect points badge | Points badge increments by awarded amount; daily streak increments if consecutive daily scan. |
| [ ] | **R-07** | Resident Profile Screen | Tap Tab 5 ("Profile") on bottom bar | Inspect profile overview | Displays avatar, display name, email, Total Points, Daily Streak, Total Scans, and unlocked Badges showcase. |
| [ ] | **R-08** | Personal Uploads Archive | On Profile, tap **"My Uploads"** button | Inspect photo feed | Opens `PImagesViewAllUserWidget`. Displays reverse-chronological photo grid of all user's uploaded waste scans with status badges (`Verified`, `Non-Verified`, `Flagged`). |
| [ ] | **R-09** | Image Detail & Flag Action | In My Uploads, tap an image card | Inspect detail modal (`c_img_view_user_widget`) | Displays high-res photo, AI confidence scores, street, and date. If flagging allowed, displays **"Flag Decision"** red flag button. |
| [ ] | **R-10** | Dispute Verification Decision | In image detail modal for any Non-Verified or Flagged scan | Tap **"Dispute Verification Decision"** (gavel icon) | Opens `CDisputeDecisionWidget`. Select a dispute reason (e.g. *"AI Misclassification"*), type an explanation ($\ge 5$ characters), and tap **"Submit Dispute"**. Displays green success toast: *"Dispute submitted successfully! Sent for verifier review."* Renders amber banner: *"Dispute Pending Verifier Review"*. |
| [ ] | **R-11** | Delete Personal Scan | In image detail modal | Tap trash icon | Launches `c_image_deletion` confirmation dialog $\to$ confirms deletion $\to$ deletes row from `Image` table. |
| [ ] | **R-12** | Account Settings Hub | On Profile, tap **"Settings"** button | Inspect settings menu | Opens `PageProfileSettingsWidget` with options: Edit Profile, Change Email, Change Password, About EBasura, Terms & Conditions, and Sign Out. |
| [ ] | **R-13** | Edit Profile Credentials | In Settings, tap "Edit Profile" | Modify display name or avatar $\to$ save | Opens `PageChangeProfileWidget`. Updates `user.display_name` in Supabase. |
| [ ] | **R-14** | Explore Audits (Read-Only) | Tap Tab 4 ("Explore") $\to$ switch to "Reports" sub-tab | Inspect list of reports | Opens `PageViewSubFeaturesWidget`. Displays completed waste audit reports. Confirms list is read-only (no creation button on resident view). |
| [ ] | **R-15** | Resident Incident Reporting | `PageProfileWidget` | Scroll to "Report Waste Incident" card $\to$ enter Subject, select Street from dropdown, enter Description, attach photo $\to$ tap "Submit Report" | Photo uploads to `Image_Bucket/Reports/`. Row inserted into Supabase `Report` table with `report_status = 'Pending'` and `reporter_userRef = currentUserUid`. Green toast displays. "View All" navigates to `PReportViewAllWidget`. |

---

## 5. Test Suite 3: Collection Crew Role Verification (`UserRole.crew`)

| Status | Verification Item | Target Screen / UI Element | Action to Perform | Expected Behavior |
| :---: | :--- | :--- | :--- | :--- |
| [ ] | **C-01** | Crew Role Activation | Set `user_type = 'crew'` in Supabase | Relaunch or refresh app | App switches to Crew layout upon session bootstrap. |
| [ ] | **C-02** | Crew Bottom Bar | `CBottomBarWidget` | Inspect bottom bar tabs | Displays exactly 4 tabs + 1 Center FAB:<br/>`[ 🚛 Routes ] [ 📋 Pickups ] [ 📷 Camera ] [ ⚠️ Reports ] [ 👤 Profile ]`. |
| [ ] | **C-03** | Crew Routes Dashboard | Tap Tab 1 ("Routes") on bottom bar | Inspect dashboard screen | Opens `PageCrewDashboardWidget`. Displays Truck Unit card (*"Truck #04 • Field Crew Unit"*), current shift status, route progress bar, and street collection checklist. |
| [ ] | **C-04** | Shift Status Selector | On `PageCrewDashboardWidget` | Tap different status pills: *Idle*, *En Route*, *In Progress*, *Completed* | Active status pill highlights with Ocean Blue background; shift status badge in top card updates instantly. |
| [ ] | **C-05** | Street Collection Checklist | On `PageCrewDashboardWidget` | Tap collection cards to toggle completion | Cards toggle green background with checkmark; top completion counter (e.g. *"3 of 8 Done"*) and linear progress bar update dynamically. |
| [ ] | **C-06** | Pickups Timetable | Tap Tab 2 ("Pickups") on bottom bar | Inspect schedule calendar | Opens `PDatesViewAllWidget`. Crew can inspect designated pickup hours, streets, and truck assignments. |
| [ ] | **C-07** | Crew Incident Reports Feed | Tap Tab 4 ("Reports") on bottom bar | Inspect report queue | Opens `PReportViewAllWidget`. Displays feed of all filed waste incident reports with status filter chips (*All*, *Pending*, *In Progress*, *Resolved*). |
| [ ] | **C-08** | File Field Incident Report | On `PReportViewAllWidget`, tap elevated **"+" Floating Action Button** | Fill form and submit | Opens `CReportCreationWidget` modal bottom sheet. Crew selects affected street, enters description, attaches photo, and taps **"Create Report"**. New report is saved to Supabase `report` table. |
| [ ] | **C-09** | Report Detail Inspector | On `PReportViewAllWidget`, tap any report card | Inspect report screen | Opens `PReportViewOneWidget`. Displays report photo, assigned street, timestamps, and resolution comments. |

---

## 6. Test Suite 4: Administrator Role Verification (`UserRole.admin`)

| Status | Verification Item | Target Screen / UI Element | Action to Perform | Expected Behavior |
| :---: | :--- | :--- | :--- | :--- |
| [ ] | **A-01** | Admin Role Activation | Set `user_type = 'admin'` in Supabase | Relaunch or refresh app | App switches to Administrator layout upon session bootstrap. |
| [ ] | **A-02** | Admin Bottom Bar | `CBottomBarWidget` | Inspect bottom bar tabs | Displays exactly 4 tabs + 1 Center FAB:<br/>`[ 📊 Dashboard ] [ 🛡️ Review ] [ 📷 Camera ] [ 👥 Users ] [ 👤 Profile ]`. |
| [ ] | **A-03** | Central Admin Dashboard | Tap Tab 1 ("Dashboard") on bottom bar | Inspect dashboard screen | Opens `PageAdminDashboardWidget`. Displays 5 live KPI metric cards (Total Users, Verified Scans, Flagged Queue, Unresolved Reports, Active Schedules) and 7 module launcher cards. |
| [ ] | **A-04** | Master Image Moderation | Tap Tab 2 ("Review") or "Image Review" card | Filter by chips: *All*, *AI*, *Segregated*, *Unsegregated*, *Flagged*, *Verified* | Opens `PImagesViewAllWidget`. Grid updates dynamically to display images matching the selected classification filter. |
| [ ] | **A-05** | Image Verifier & Override | In `PImagesViewAllWidget`, tap an image card | Inspect verifier screen | Opens `PImgViewVerifierWidget`. Shows dual-column comparison (AI prediction vs Ground-Truth Admin overrides). Admin can toggle "Verified", override waste category dropdown, toggle "Allow Flagging", and tap **"Verify"** / **"Update"**. |
| [ ] | **A-06** | Flagged Images Quarantine | On Admin Dashboard, tap **"Flagged Images Queue"** card | Inspect quarantine list | Opens `PageFilteredImagesWidget`. Displays uploads intercepted by Gemini prompt-injection defense or safety heuristics. Admin can confirm violation or dismiss flag. |
| [ ] | **A-07** | User Management Console | Tap Tab 4 ("Users") or "User Management" card | Search users by name/email | Opens `PageUserManagementWidget`. Displays list of registered accounts. Tap a user card to open management sheet: adjust role (`resident` $\leftrightarrow$ `crew` $\leftrightarrow$ `admin`), credit/deduct points, or toggle suspension. |
| [ ] | **A-08** | Collection Schedule CRUD | On Admin Dashboard, tap **"Collection Dates"** card | Test Add, Edit, Delete | Opens `PDatesViewAllWidget`. Tap "+ Add Schedule" to open `c_dates_creation`. Tap existing card to edit (`c_dates_update`) or delete (`c_dates_deletion`). Modifies Supabase `collection` table. |
| [ ] | **A-09** | Street Directory CRUD | On Admin Dashboard, tap **"Streets Directory"** card | Test Add, Edit, Delete | Opens `PStreetViewAllWidget`. Tap "+ Add Street" to open `c_street_creation`. Tap existing card to edit (`c_street_update`) or delete (`c_street_deletion`). Modifies Supabase `street` table. |
| [ ] | **A-10** | Badge Administration CRUD | On Admin Dashboard, tap **"Badges"** card | Test badge creation | Opens `PBadgeViewAllWidget`. Tap "+ Create Badge" to open `c_badges_creation`. Enter title, points threshold, and upload PNG icon to `badges/` storage bucket. Tap delete icon on badge to trigger `c_badges_deletion`. |
| [ ] | **A-11** | System Waste Reports Hub | On Admin Dashboard, tap **"Waste Reports"** card | Inspect macro analytics | Opens `PReportSystemWidget`. Displays Total Created Reports hero counter and per-street image aggregation tallies. Tap top banner $\to$ deep-links into `PReportViewAllWidget` $\to$ tap report $\to$ opens `PReportViewOneWidget` with "Delete" and "Update" buttons. |

---

## 7. QA Verification Summary Sign-Off Sheet

```text
===================================================================
                  EBASURA QA VERIFICATION SIGN-OFF
===================================================================
Tester Name:        ___________________________
Test Date:          ___________________________
Device / OS:        ___________________________
Flutter Version:    ___________________________
Target Branch:      feat/rd-update

[ ] Test Suite 1: Guest Role (11 Items)          Pass: ___ / 11
[ ] Test Suite 2: Resident Role (14 Items)       Pass: ___ / 14
[ ] Test Suite 3: Collection Crew (9 Items)      Pass: ___ / 9
[ ] Test Suite 4: Administrator (11 Items)       Pass: ___ / 11

Total Verification Score:  ___ / 45 Checks Passed
Sign-Off Status:           [  ] APPROVED   [  ] ACTION REQUIRED
===================================================================
```
