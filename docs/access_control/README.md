# Role-Based Access Control (RBAC) & Navigation Directory

## 1. Overview & Architecture

EBasura enforces a client-side and backend-verified **Role-Based Access Control (RBAC)** architecture designed to balance open public accessibility for waste awareness with strict data isolation and elevated administrative governance.

The platform distinguishes four distinct operational tiers:
1. **Guest (`UserRole.guest`)**: Unauthenticated visitors or first-time community users exploring recycling guides, checking collection schedules, and testing AI waste classification without an account.
2. **Resident (`UserRole.resident`)**: Verified community members with confirmed email credentials participating in daily waste classification, earning gamification points, unlocking badges, filing waste reports, and tracking personal scan histories.
3. **Administrator (`UserRole.admin`)**: Barangay officials and system administrators managing platform moderation, reviewing flagged uploads, adjusting user roles, updating street collection schedules, and authoring achievement badges.
4. **Collection Crew (`UserRole.crew`)**: Municipal or barangay waste collection personnel operating specialized route tracking, pickup checklist verification, and route-level incident reporting.

```mermaid
flowchart TD
    Start(["User Launches EBasura"]) --> AuthCheck{"Is User Authenticated?<br/>(currentUser.uid != null)"}
    
    AuthCheck -- No --> GuestSession["Role: UserRole.guest<br/>(Anonymous Session)"]
    GuestSession --> GuestUI["Guest Bottom Bar<br/>(Home | Rankings | Camera | Explore | Sign In)"]
    GuestUI --> GuestScan["Guest AI Scanner<br/>(PImgUploadAGuestWidget)"]
    GuestUI --> PublicSchedule["View Public Schedules & Sub-Features"]
    GuestUI --> AuthPrompt["Auth Gate / Landing Page"]

    AuthCheck -- Yes --> RoleQuery["Query Supabase 'user' Table<br/>(RoleService.fetchCurrentUserRole)"]
    RoleQuery --> RoleBranch{"User user_type Field"}

    RoleBranch -- "resident / user / null" --> ResidentSession["Role: UserRole.resident"]
    ResidentSession --> ResidentUI["Resident Bottom Bar<br/>(Home | Rankings | Camera | Explore | Profile)"]
    ResidentUI --> ResidentScan["Auth AI Scanner + Points<br/>(PImgUploadAAuthWidget)"]
    ResidentUI --> ResidentReports["File Incident Reports & My Uploads"]
    ResidentUI --> ResidentProfile["Profile & Account Settings"]

    RoleBranch -- "admin" --> AdminSession["Role: UserRole.admin"]
    AdminSession --> AdminUI["Admin Bottom Bar<br/>(Dashboard | Review | Camera | Users | Profile)"]
    AdminUI --> AdminDash["Admin Operations Hub<br/>(PageAdminDashboardWidget)"]
    AdminUI --> ModerationQueue["Image Review & Flagged Queue"]
    AdminUI --> UserManage["User Management & Role Elevation"]

    RoleBranch -- "crew" --> CrewSession["Role: UserRole.crew"]
    CrewSession --> CrewUI["Crew Bottom Bar<br/>(Routes | Pickups | Camera | Reports | Profile)"]
    CrewUI --> CrewDash["Crew Route Dashboard<br/>(PageCrewDashboardWidget)"]
```

---

## 2. Master Access Control Matrix

The following matrix cross-references application features with permitted user tiers:

| Functional Area | Route / Primary Component | Guest (`guest`) | Resident (`resident`) | Admin (`admin`) | Crew (`crew`) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Auth Gateway & Registration** | `LandingPageWidget` (`/landingPage`) | Full Access | Auto-redirect | Auto-redirect | Auto-redirect |
| **Guest AI Waste Scanner** | `PImgUploadAGuestWidget` (`/pImgUploadAGuest`) | Full Access | Optional | Optional | Optional |
| **Authenticated AI Scanner** | `PImgUploadAAuthWidget` (`/pImgUploadAAuth`) | Gated (Prompt Sign In) | Full Access (Awards Points) | Full Access (No Points) | Full Access |
| **Gamification Points & Streaks** | `lib/custom_code/actions/` | Read-only | Earn & Level-up | Manage/Audit | View |
| **Personal Uploads Archive** | `PImagesViewAllUserWidget` (`/pImagesViewAllUser`) | Gated | Full Access | Full Access | Full Access |
| **Community Leaderboard** | `PageLeaderboardWidget` (`/pageLeaderboard`) | Read-only Feed | Ranked Participant | Moderator View | Participant |
| **Waste Incident Reporting** | `PReportSystemWidget` (`/pReportSystem`) | Gated | Submit Reports | Submit & Resolve | Submit & Resolve |
| **Public Schedules & Streets** | `PDatesViewAllWidget`, `PStreetViewOneWidget` | Read-only | Read & Filter | Read & Author | Assigned Routes |
| **Sub-Features Directory** | `PageViewSubFeaturesWidget` (`/pageViewSubFeatures`) | Read-only | Full Access | Full Access | Full Access |
| **Profile & Settings** | `PageProfileWidget` (`/pageProfile`) | Gated (Sign In CTA) | Full Access | Full Access | Full Access |
| **Admin Operations Dashboard** | `PageAdminDashboardWidget` (`/pageAdminDashboard`) | Blocked | Blocked | Full Access | Blocked |
| **User Role & Points Management** | `PageUserManagementWidget` (`/pageUserManagement`) | Blocked | Blocked | Full Access | Blocked |
| **Image Moderation & Verifier** | `PImagesViewAllWidget`, `PImgViewVerifierWidget` | Blocked | Blocked | Full Access | Blocked |
| **Flagged Images & AI Quarantine** | `PageFilteredImagesWidget` (`/pageFilteredImages`) | Blocked | Blocked | Full Access | Blocked |
| **Schedule & Street Authoring** | `lib/admin/dates/`, `lib/admin/street/` | Blocked | Blocked | Full CRUD | Blocked |
| **Badge Creation & Revocation** | `PBadgeViewAllWidget`, `lib/admin/badges/` | Blocked | Blocked | Full CRUD | Blocked |
| **Crew Dispatch Dashboard** | `PageCrewDashboardWidget` (`/pageCrewDashboard`) | Blocked | Blocked | Viewable | Full Access |

---

## 3. Dynamic Navigation Engine (`CBottomBarWidget`)

Navigation adaptation is orchestrated centrally through `lib/components/c_bottom_bar/c_bottom_bar_widget.dart`. On initialization, the widget inspects the current authentication state and evaluates `RoleService.fetchCurrentUserRole()`:

```dart
// Role-based Bottom Bar Layout Selector
if (_currentRole == UserRole.crew) {
  // Routes | Pickups | [Camera FAB] | Reports | Profile
} else if (_currentRole == UserRole.admin) {
  // Dashboard | Review | [Camera FAB] | Users | Profile
} else {
  // Home | Rankings | [Camera FAB] | Explore | Profile (or Sign In if Guest)
}
```

The center Floating Action Button (FAB) dynamically redirects based on role:
- **Guests (`currentUserUid.isEmpty`)**: Redirects to `PImgUploadAGuestWidget`.
- **Residents (`_currentRole != UserRole.admin`)**: Redirects to `PImgUploadAAuthWidget` with `autoTriggerCamera: true`.
- **Admins**: Redirects to `PImgUploadAAuthWidget` in manual upload/moderation mode.

---

## 4. Role Documentation Guides

For complete lists of accessible features, route identifiers, and step-by-step navigation instructions for each role, consult the dedicated guides below:

1. 📖 **[`guest_access.md`](guest_access.md)** — Comprehensive guide for Guest users, unauthenticated exploration, guest scanning, and auth conversion gates.
2. 📖 **[`resident_access.md`](resident_access.md)** — Comprehensive guide for Community Residents, camera flows, points & badges, waste reporting, and account management.
3. 📖 **[`admin_access.md`](admin_access.md)** — Comprehensive guide for Barangay Administrators, KPI dashboards, moderation galleries, user role editing, schedule authoring, and security audits.
