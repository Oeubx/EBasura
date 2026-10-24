# Administrator Access & Navigation Guide

## 1. User Persona & Scope

The **Administrator** tier (`UserRole.admin`) is granted to Barangay Officials, municipal waste officers, and platform operators whose accounts have an elevated `user_type = 'admin'` attribute in the Supabase `user` table. 

Administrators govern the entire EBasura ecosystem: overseeing community waste metrics, verifying resident waste photos, moderating flagged or injected content, managing resident accounts and roles, authoring pickup schedules, defining street directories, and creating community achievement badges.

---

## 2. Complete List of Accessible Features

| Feature ID | Screen / Component Name | Route Path | Primary Purpose |
| :--- | :--- | :--- | :--- |
| **ADM-01** | `PageAdminDashboardWidget` | `/pageAdminDashboard` | Central administrative command hub featuring live platform KPIs and quick-action module launchers. |
| **ADM-02** | `PImagesViewAllWidget` | `/pImagesViewAll` | Master image moderation gallery with tabbed classification filters (All, AI, Segregated, Flagged, Verified). |
| **ADM-03** | `PImgViewVerifierWidget` | `/pImgViewVerifier` | Single-image inspection modal: verify waste classification, override categories, or confirm flags. |
| **ADM-04** | `PageFilteredImagesWidget` | `/pageFilteredImages` | Dedicated quarantine queue for scans flagged for prompt injection, non-waste content, or visual anomalies. |
| **ADM-05** | `PImagesViewAllFlaggedWidget` | `/pImagesViewAllFlagged` | Filtered gallery view isolating flagged and suspicious community uploads. |
| **ADM-06** | `PImagesViewAllVerifiedWidget` | `/pImagesViewAllVerified` | Filtered gallery view of officially confirmed and verified waste scans. |
| **ADM-07** | `PImagesViewAllSegregatedWidget` | `/pImagesViewAllSegregated` | Filtered gallery view of properly segregated recyclable and compostable waste. |
| **ADM-08** | `PImagesViewAllUnsegregatedWidget` | `/pImagesViewAllUnsegregated` | Filtered gallery view of unsegregated, contaminated, or mixed waste uploads. |
| **ADM-09** | `PImagesViewAllAiWidget` | `/pImagesViewAllAi` | Filtered gallery view of raw Gemini AI classification results pending official review. |
| **ADM-10** | `PageUserManagementWidget` | `/pageUserManagement` | User administration console: search users, adjust eco-points, promote to Admin/Crew, or suspend accounts. |
| **ADM-11** | `PDatesViewAllWidget` | `/pDatesViewAll` | Collection schedule administration hub with Add/Edit/Delete action modal triggers. |
| **ADM-12** | `c_dates_creation` | Bottom Sheet / Modal | Modal form to schedule new garbage collection dates, time ranges, and assigned zones. |
| **ADM-13** | `c_dates_update` | Bottom Sheet / Modal | Modal form to modify existing pickup times, assigned drivers, or notes. |
| **ADM-14** | `c_dates_deletion` | Confirmation Dialog | Secure deletion dialog to cancel and remove obsolete collection schedules. |
| **ADM-15** | `PStreetViewAllWidget` | `/pStreetViewAll` | Barangay street and zone directory hub with Add/Edit/Delete action modal triggers. |
| **ADM-16** | `c_street_creation` | Bottom Sheet / Modal | Modal form to register new streets, subdivisions, or collection zones into the directory. |
| **ADM-17** | `c_street_update` | Bottom Sheet / Modal | Modal form to edit street names, zone assignments, and route descriptions. |
| **ADM-18** | `c_street_deletion` | Confirmation Dialog | Secure deletion dialog to retire streets from the directory. |
| **ADM-19** | `PBadgeViewAllWidget` | `/pBadgeViewAll` | Badge administration console: author custom badges, upload icon assets, and set unlock thresholds. |
| **ADM-20** | `c_badges_creation` | Bottom Sheet / Modal | Modal form to author new achievement badges with icon upload to Supabase Storage. |
| **ADM-21** | `c_badges_deletion` | Confirmation Dialog | Secure deletion dialog to retire or revoke deprecated badges. |
| **ADM-22** | `PReportViewAllWidget` | `/pReportViewAll` | Community incident report management queue to oversee and resolve resident dumping complaints. |
| **ADM-23** | `PReportViewOneWidget` | `/pReportViewOne` | Detailed incident inspector to update report resolution status (`Pending`, `In Progress`, `Resolved`). |
| **ADM-24** | `PReportSystemWidget` | `/pReportSystem` | Administrative waste audit filing tool to conduct scheduled barangay waste assessments. |
| **ADM-25** | `PImgUploadAAuthWidget` | `/pImgUploadAAuth` | Authenticated camera scanner for on-site administrative waste verification. |
| **ADM-26** | `PageProfileWidget` | `/pageProfile` | Admin profile card and credentials management. |
| **ADM-27** | `PageProfileSettingsWidget` | `/pageProfileSettings` | Settings hub for administrative password and contact updates. |

---

## 3. How to Access All Administrator Features (Step-by-Step)

### 3.1 Navigating via the Admin Bottom Navigation Bar
When authenticated with `user_type = 'admin'`, `CBottomBarWidget` automatically renders the administrative layout:

```
[ 📊 Dashboard ]   [ 🛡️ Review ]   [ 📷 Camera ]   [ 👥 Users ]   [ 👤 Profile ]
```

1. **Tab 1: Dashboard (`PageAdminDashboardWidget`)**:
   - **Click Path**: Tap the first icon labelled **Dashboard**.
   - **Features Available**:
     - View real-time platform metrics: **Total Registered Users**, **Verified Scans**, **Pending Flagged Queue**, **Unresolved Reports**, and **Active Collection Schedules**.
     - Launchpad containing 7 dedicated module launcher cards (Image Review, Collection Dates, Waste Reports, User Management, Streets Directory, Badges, Flagged Images).
2. **Tab 2: Review (`PImagesViewAllWidget`)**:
   - **Click Path**: Tap the second icon labelled **Review**.
   - **Features Available**:
     - Instant entry to the Master Image Moderation Gallery.
     - Filter between all waste uploads across the community.
3. **Center FAB: Camera (`PImgUploadAAuthWidget`)**:
   - **Click Path**: Tap the elevated circular camera button.
   - **Features Available**: Launches the on-site camera for official verification scans.
4. **Tab 3: Users (`PageUserManagementWidget`)**:
   - **Click Path**: Tap the fourth icon labelled **Users**.
   - **Features Available**:
     - Instant entry to the User Management and Auditing console.
5. **Tab 4: Profile (`PageProfileWidget`)**:
   - **Click Path**: Tap the fifth icon labelled **Profile**.
   - **Features Available**: Admin account management and sign-out.

---

### 3.2 Accessing Features from the Admin Dashboard Launchpad
On `PageAdminDashboardWidget`, scroll past the KPI cards to access the **7 Core Administrative Hubs**:

```
+-----------------------------------+-----------------------------------+
| 🖼️ Image Review                   | 📅 Collection Dates               |
| -> Master Moderation Gallery      | -> Author & Update Schedules      |
+-----------------------------------+-----------------------------------+
| 📋 Waste Reports                  | 👥 User Management                |
| -> Incident Resolution & Audits   | -> Roles, Points & Status         |
+-----------------------------------+-----------------------------------+
| 🗺️ Streets Directory             | 🏅 Badges                         |
| -> Route & Zone Management        | -> Create & Revoke Badges         |
+-----------------------------------+-----------------------------------+
| ⚠️ Flagged Images Queue           |                                   |
| -> AI Prompt Injection Quarantine |                                   |
+-----------------------------------+-----------------------------------+
```

#### 1. How to Access Image Moderation (`PImagesViewAllWidget`):
1. Tap the **"Image Review"** card on the dashboard (or Tab 2 on the bottom bar).
2. Use the top horizontal filter chips to switch views:
   - `All`: Complete archive of community scans.
   - `AI Classified`: Scans evaluated by Gemini awaiting admin confirmation (`PImagesViewAllAiWidget`).
   - `Segregated`: Confirmed clean, recyclable/compostable waste (`PImagesViewAllSegregatedWidget`).
   - `Unsegregated`: Mixed or contaminated waste items (`PImagesViewAllUnsegregatedWidget`).
   - `Flagged`: Suspicious, non-waste, or offensive uploads (`PImagesViewAllFlaggedWidget`).
   - `Verified`: Formally inspected and approved items (`PImagesViewAllVerifiedWidget`).
3. Tap any image card to open the **Image Verifier Modal** (`PImgViewVerifierWidget`):
   - Review AI classification confidence, user details, and timestamp.
   - Tap **"Verify"** to mark the image as confirmed.
   - Tap **"Override Category"** to correct an AI misclassification.
   - Tap **"Flag Image"** to quarantine the image and deduct suspicious points.

#### 2. How to Access the Flagged & Prompt Injection Queue (`PageFilteredImagesWidget`):
1. Tap the **"Flagged Images Queue"** card on the dashboard.
2. Review items that triggered Gemini AI prompt injection guardrails or were flagged by community heuristics.
3. For each flagged item:
   - Inspect the reason code (e.g., `PROMPT_INJECTION_SUSPECT`, `NON_WASTE_CONTENT`, `BLURRY_UNREADABLE`).
   - Select **"Confirm Violation"** (revokes points and warns user) or **"False Positive - Dismiss Flag"** (restores points to user).

#### 3. How to Access User Management & Role Elevation (`PageUserManagementWidget`):
1. Tap the **"User Management"** card on the dashboard (or Tab 4 on the bottom bar).
2. View the full list of registered community accounts loaded from the `user` table.
3. **Search & Filter**: Type in the top search bar to filter by name or email. Filter by role (`Resident`, `Crew`, `Admin`).
4. **Edit User Role / Status**:
   - Tap on a user entry to open their management bottom sheet.
   - **Change Role**: Select from dropdown (`resident`, `crew`, `admin`) and confirm elevation.
   - **Adjust Points**: Manually credit or deduct eco-points with an audit reason note.
   - **Suspend / Reactivate**: Toggle account status to prevent suspicious users from submitting scans.

#### 4. How to Manage Garbage Collection Schedules (`PDatesViewAllWidget`):
1. Tap the **"Collection Dates"** card on the dashboard.
2. View all scheduled pickups sorted by date.
3. **Create New Schedule**:
   - Tap the **"+ Add Schedule"** floating button or header action.
   - Modal `c_dates_creation` opens: select date, start/end time, collection zone/street, and truck crew.
   - Tap **"Save Schedule"** to write to Supabase `collection` table.
4. **Edit / Delete Schedule**:
   - Tap any existing schedule card to view details (`PDatesViewOneWidget`).
   - Tap the pencil icon to edit (`c_dates_update`).
   - Tap the trash icon to open the deletion confirmation modal (`c_dates_deletion`).

#### 5. How to Manage the Street Directory (`PStreetViewAllWidget`):
1. Tap the **"Streets Directory"** card on the dashboard.
2. View all barangay coverage streets and zones.
3. **Add New Street**:
   - Tap **"+ Add Street"** to open `c_street_creation`.
   - Enter Street Name (e.g., *"Sampaguita Street"*), Barangay Zone, and Collection Frequency.
   - Tap **"Create Street"** to save to `street` table.
4. **Edit / Delete Street**:
   - Tap on a street card to open `PStreetViewOneWidget`.
   - Tap edit (`c_street_update`) or delete (`c_street_deletion`).

#### 6. How to Author & Manage Achievement Badges (`PBadgeViewAllWidget`):
1. Tap the **"Badges"** card on the dashboard.
2. Inspect the catalog of active gamification badges.
3. **Create New Badge**:
   - Tap **"+ Create Badge"** to open `c_badges_creation`.
   - Enter Badge Title (e.g., *"Compost Master"*), Description, Points Required, and Minimum Scans.
   - Tap the image upload box to select a custom PNG/SVG badge icon; the file is uploaded to the Supabase `badges` storage bucket.
   - Tap **"Publish Badge"** to make it available for community unlock.
4. **Delete / Revoke Badge**:
   - Tap an existing badge card -> tap delete (`c_badges_deletion`).

#### 7. How to Oversee & Resolve Waste Incident Reports:
1. Tap the **"Waste Reports"** card on the dashboard.
2. View the incoming queue of resident-reported dumping issues (`PReportViewAllWidget`).
3. Tap any report row to open `PReportViewOneWidget`:
   - Inspect the geo-tagged street, attached photograph, and resident description.
   - Change report status dropdown:
     - `Pending` (Received, awaiting review)
     - `In Progress` (Dispatched crew to location)
     - `Resolved` (Cleanup complete, photo verified)
   - Add admin resolution notes; tap **"Update Status"**.

---

## 4. Security Enforcement & Admin Route Guards

Administrative privileges are enforced at two levels:
1. **Client-Side RBAC Guard (`lib/auth/role_util.dart`)**:
   - Evaluated via `RoleService.isAdmin(user.userType)`.
   - If an unauthenticated user or non-admin resident attempts to navigate directly to `/pageAdminDashboard` or administrative routes, GoRouter intercepts the navigation and redirects to `/pageHomepage` or `/landingPage`.
2. **Backend Row-Level Security (RLS) in Supabase**:
   - Database mutation policies for tables (`collection`, `street`, `badge_record`, `user`) require `auth.jwt() ->> 'role' = 'admin'` or verified administrative claims, preventing unauthorized direct REST API manipulation.
