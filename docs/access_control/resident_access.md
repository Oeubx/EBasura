# Resident Access & Navigation Guide

## 1. User Persona & Scope

The **Resident** tier (`UserRole.resident`) represents verified community members who have registered and confirmed their email addresses. Residents have full access to EBasura's gamified recycling platform: they scan waste using the Gemini-powered AI classifier, earn recycling points and streaks, unlock badges, report illegal dumping incidents, view their personal upload archives, and monitor barangay garbage collection schedules.

---

## 2. Complete List of Accessible Features

| Feature ID | Screen / Component Name | Route Path | Primary Purpose |
| :--- | :--- | :--- | :--- |
| **RES-01** | `PageHomepageWidget` | `/` or `/pageHomepage` | Authenticated community dashboard with personal stats, next pickup alert, and quick action cards. |
| **RES-02** | `PImgUploadAAuthWidget` | `/pImgUploadAAuth` | Authenticated AI Waste Scanner with automatic camera trigger, Gemini analysis, and points rewards. |
| **RES-03** | `PImagesViewAllUserWidget` | `/pImagesViewAllUser` | Personal timeline and gallery of all waste scans uploaded by the user with moderation badges. |
| **RES-04** | `PReportSystemWidget` | `/pReportSystem` | Waste incident reporting form (illegal dumping, overflow, missed collection) with photo capture. |
| **RES-05** | `PReportViewAllWidget` | `/pReportViewAll` | Community feed of all filed waste reports and resolution statuses. |
| **RES-06** | `PReportViewOneWidget` | `/pReportViewOne` | Detailed report view showing photos, barangay resolution status, and inspection notes. |
| **RES-07** | `PageLeaderboardWidget` | `/pageLeaderboard` | Full interactive community leaderboard displaying top recyclers, rank podium, and user's standing. |
| **RES-08** | `PDatesViewAllWidget` | `/pDatesViewAll` | Barangay collection calendar and list of upcoming pickup dates per street. |
| **RES-09** | `PDatesViewOneWidget` | `/pDatesViewOne` | Specific collection date details, pickup hours, and assigned truck crew. |
| **RES-10** | `PStreetViewOneWidget` | `/pStreetViewOne` | Street directory profile displaying designated pickup windows and guidelines. |
| **RES-11** | `PageViewSubFeaturesWidget` | `/pageViewSubFeatures` | Sub-features discovery directory covering audits, collection guidelines, and metrics. |
| **RES-12** | `PageProfileWidget` | `/pageProfile` | User profile overview with point totals, unlocked badges, scan counts, and streak tracking. |
| **RES-13** | `PageProfileSettingsWidget` | `/pageProfileSettings` | Account settings hub containing profile modification, credentials, and about links. |
| **RES-14** | `PageChangeProfileWidget` | `/pageChangeProfile` | Form to edit display name, profile avatar, and contact details. |
| **RES-15** | `PageChangeEmailWidget` | `/pageChangeEmail` | Form to update registered email address with OTP confirmation. |
| **RES-16** | `PageChangePasswordWidget` | `/pageChangePassword` | Form to update account password with validation guards. |
| **RES-17** | `PageProfileAboutWidget` | `/pageProfileAbout` | About EBasura mission and background. |
| **RES-18** | `PageProfileAboutADETWidget` | `/pageProfileAboutADET` | Institutional project background and development credits. |
| **RES-19** | `PageProfileAboutResearchWidget` | `/pageProfileAboutResearch` | Technical and ethical research context on computer vision waste characterization. |
| **RES-20** | `TermsAndConditionsWidget` | `/termsAndConditions` | Application terms of use and data privacy agreement. |

---

## 3. How to Access All Resident Features (Step-by-Step)

### 3.1 Navigating via the Resident Bottom Navigation Bar
When authenticated as a resident, `CBottomBarWidget` displays a 4-tab bar tailored for community participation with an elevated center camera button:

```
[ 🏠 Home ]   [ 🏆 Rankings ]   [ 📷 Camera ]   [ 🧭 Explore ]   [ 👤 Profile ]
```

1. **Tab 1: Home (`PageHomepageWidget`)**:
   - **Click Path**: Tap the first icon labelled **Home**.
   - **Features Available**:
     - View greeting *"Hello, [Your Name]"*.
     - Tap the **Points & Rank** badge pill to jump directly to the **Leaderboard**.
     - View the **Upcoming Collection Alert** banner for your registered street.
     - Quick Action Launcher:
       - **Scan Waste** -> Launches `PImgUploadAAuthWidget`.
       - **Collection Schedules** -> Launches `PDatesViewAllWidget`.
       - **Waste Reporting** -> Launches `PReportSystemWidget`.
       - **Leaderboard** -> Launches `PageLeaderboardWidget`.
2. **Tab 2: Rankings (`PageLeaderboardWidget`)**:
   - **Click Path**: Tap the second icon labelled **Rankings**.
   - **Features Available**:
     - Inspect top 3 podium recyclers in the barangay.
     - View your highlighted position, rank number, total eco-points, and current tier.
     - Scroll through the community rankings table.
3. **Center FAB: Camera (`PImgUploadAAuthWidget`)**:
   - **Click Path**: Tap the elevated circular camera button in the center.
   - **Behavior**: Opens the Authenticated Scanner with `autoTriggerCamera: true`, automatically launching the camera viewfinder.
4. **Tab 3: Explore (`PageViewSubFeaturesWidget`)**:
   - **Click Path**: Tap the fourth icon labelled **Explore**.
   - **Features Available**:
     - Browse all barangay collection schedules.
     - Review public waste audit reports filed by collection crews and barangay inspectors.
     - View community recycling metric cards (total items classified, segregated vs unsegregated).
5. **Tab 4: Profile (`PageProfileWidget`)**:
   - **Click Path**: Tap the fifth icon labelled **Profile**.
   - **Features Available**:
     - Profile avatar, display name, and registered email.
     - Metric cards: **Total Points**, **Daily Streak**, and **Total Scans**.
     - Badges showcase with unlocked vs locked status.
     - Action buttons: **"My Uploads"** and **"Settings"**.
     - **Sign Out** button.

---

### 3.2 Accessing & Performing an AI Waste Scan
1. **Launch Scanner**:
   - **Option A**: Tap the **Center Camera FAB** on the bottom navigation bar.
   - **Option B**: Tap the **"Scan Waste"** action card on the Homepage.
2. **Capture or Upload Image**:
   - Point camera at the waste item (e.g., plastic bottle, food scraps, cardboard box).
   - Tap the shutter button or select an existing photo from the gallery.
3. **AI Inference & Result Presentation**:
   - EBasura sends the image to Google Gemini REST API.
   - Gemini classifies the material type (*Plastic, Paper, Organic, Metal, Glass, Hazardous*) and segregation accuracy (*Segregated vs Unsegregated*).
4. **Points & Rewards Persistence**:
   - Eco-points are automatically calculated and added to the user's Supabase profile.
   - The scan is stored in the `image_record` and `waste_item` tables.
   - If consecutive daily scanning is maintained, the daily streak count increments.
5. **Post-Scan Navigation**:
   - Tap **"Done"** to return to Homepage, or **"Scan Another"** to capture another item.

---

### 3.3 Accessing Personal Upload History ("My Uploads")
1. Tap the **Profile** tab (Tab 4) on the bottom navigation bar.
2. Scroll to the action section below your badges.
3. Tap the **"My Uploads"** pill button (`ebasuraSecondaryButton`).
4. This navigates to `PImagesViewAllUserWidget`:
   - View a complete reverse-chronological photo grid of all your uploaded waste items.
   - Each photo displays its AI classification label, timestamp, and verification badge (`AI Verified`, `Pending Moderation`, `Flagged`).
   - Tap any card to open the detail dialog with full AI confidence scores and recycling tips.

---

### 3.4 Submitting a Waste Incident Report
1. **Initiate Report**:
   - **Option A**: On the Homepage, tap the **"Waste Reporting"** quick action card.
   - **Option B**: In the Explore directory (`PageViewSubFeaturesWidget`), tap **"File Report"**.
2. **Complete the Report Form (`PReportSystemWidget`)**:
   - Tap the camera placeholder to attach a photo of the waste issue (e.g., illegal roadside dump, overflowing bin).
   - Select the affected street from the dropdown list.
   - Enter a brief description of the issue.
   - Tap **"Submit Report"**.
3. **Track Report Status**:
   - Tap **"View All Reports"** to navigate to `PReportViewAllWidget`.
   - Locate your submitted report; tap to view the detail page (`PReportViewOneWidget`).
   - Monitor the resolution status as Barangay Officials inspect and resolve the issue (`Pending` -> `In Progress` -> `Resolved`).

---

### 3.5 Managing Profile & Account Settings
1. Tap the **Profile** tab on the bottom navigation bar.
2. Tap the **"Settings"** pill button (`ebasuraSecondaryButton`) to open `PageProfileSettingsWidget`.
3. Select any setting category:
   - **Edit Profile**: Tap to open `PageChangeProfileWidget` to edit your display name or avatar.
   - **Change Email**: Tap to open `PageChangeEmailWidget` to enter a new email and verify via OTP.
   - **Change Password**: Tap to open `PageChangePasswordWidget` to securely update your password.
   - **About EBasura**: Tap to open `PageProfileAboutWidget`.
   - **Terms & Conditions**: Tap to open `TermsAndConditionsWidget`.
   - **Sign Out**: Tap the red sign-out tile to clear session tokens and return to `LandingPageWidget`.

---

## 4. Resident Data Persistence & Supabase Integration

Resident actions trigger automated database updates across Supabase tables:

| Resident Action | Supabase Target Table | Operations Performed |
| :--- | :--- | :--- |
| **AI Waste Scan** | `image_record`, `waste_item`, `user` | Uploads image to Supabase Storage, inserts metadata, appends points to `user.user_pts`, increments `user.user_streak`. |
| **Badge Qualification** | `badge_record`, `badge_award` | Evaluates eligibility conditions (e.g., 50 scans, 7-day streak) and links new badge. |
| **Waste Incident Filing** | `report` | Inserts report row with photo URL, `user_idRef`, `street_idRef`, and status `'Pending'`. |
| **Profile Edits** | `user` | Updates `display_name`, `avatar_url`, or `phone_number`. |
