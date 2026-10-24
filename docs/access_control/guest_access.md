# Guest Access & Navigation Guide

## 1. User Persona & Scope

The **Guest** tier (`UserRole.guest`) is designed for community residents, visitors, and first-time users who have not yet registered or authenticated their accounts. EBasura adopts an "Open Door" sustainability philosophy: essential educational and utility features—such as checking when the garbage truck arrives, viewing public waste audit summaries, and testing the AI waste scanner—are accessible without requiring account creation.

---

## 2. Complete List of Accessible Features

| Feature ID | Screen / Component Name | Route Path | Primary Purpose |
| :--- | :--- | :--- | :--- |
| **GST-01** | `LandingPageWidget` | `/landingPage` | Welcome splash, gateway to registration, login, or guest continuation. |
| **GST-02** | `PageSignUpWidget` | `/pageSignUp` | Account registration form with name, email, street, and password. |
| **GST-03** | `PageSignInWidget` | `/pageSignIn` | Existing account authentication with email and password. |
| **GST-04** | `PageForgotPasswordWidget` | `/pageForgotPassword` | Password recovery via automated reset email. |
| **GST-05** | `TermsAndConditionsWidget` | `/termsAndConditions` | Public terms of service and data privacy notices. |
| **GST-06** | `PageVerifyEmailWidget` | `/pageVerifyEmail` | OTP verification screen to activate newly created accounts. |
| **GST-07** | `PageHomepageWidget` | `/` or `/pageHomepage` | Guest dashboard with "Eco Explorer" identity, schedule alerts, and quick actions. |
| **GST-08** | `PImgUploadAGuestWidget` | `/pImgUploadAGuest` | Guest AI Waste Scanner (Gemini vision classification with zero data persistence). |
| **GST-09** | `PDatesViewAllWidget` | `/pDatesViewAll` | Public calendar of municipal and barangay garbage collection schedules. |
| **GST-10** | `PDatesViewOneWidget` | `/pDatesViewOne` | Detailed schedule view including pickup hours and assigned waste types. |
| **GST-11** | `PStreetViewOneWidget` | `/pStreetViewOne` | Street directory entry detailing route coverage and schedules. |
| **GST-12** | `PageViewSubFeaturesWidget` | `/pageViewSubFeatures` | Sub-features directory covering collection schedules, waste audits, and image statistics. |
| **GST-13** | `PageLeaderboardWidget` | `/pageLeaderboard` | Read-only community recycling leaderboard showing top recyclers and podium. |
| **GST-14** | `PReportViewOneWidget` | `/pReportViewOne` | Public audit and waste report inspection. |
| **GST-15** | `PageProfileAboutWidget` | `/pageProfileAbout` | Information about the EBasura application mission and background. |
| **GST-16** | `PageProfileAboutADETWidget` | `/pageProfileAboutADET` | Institutional and course development context. |
| **GST-17** | `PageProfileAboutResearchWidget` | `/pageProfileAboutResearch` | Research background on automated waste characterization. |

---

## 3. How to Access All Guest Features (Step-by-Step)

### 3.1 Entering Guest Mode from App Launch
1. Launch EBasura on a mobile device or emulator.
2. If unauthenticated, the application displays the **Landing Page** (`LandingPageWidget`).
3. Tap **"Continue as Guest"** (or explore directly if routed to the root page).
4. The application transitions to the **Homepage** (`PageHomepageWidget`) with the guest header title *"Hello, Eco Explorer"*.

---

### 3.2 Navigating via the Guest Bottom Navigation Bar
Guests are presented with a 4-tab bar and a center camera action button:

```
[ 🏠 Home ]   [ 🏆 Rankings ]   [ 📷 Camera ]   [ 🧭 Explore ]   [ 🔑 Sign In ]
```

1. **Tab 1: Home (`PageHomepageWidget`)**:
   - **Click Path**: Tap the first icon labelled **Home**.
   - **Features Available**:
     - View personalized Eco Explorer greeting and promotional banner encouraging account creation.
     - View upcoming collection schedule preview card.
     - Quick action buttons to launch Scanner, Schedules, or Explore.
2. **Tab 2: Rankings (`PageLeaderboardWidget`)**:
   - **Click Path**: Tap the second icon labelled **Rankings**.
   - **Features Available**:
     - View the Top 3 podium recyclers in the barangay.
     - Scroll through ranked community members, their recycling points, and tiers.
     - Bottom persistent prompt: *"Join the Leaderboard — Sign In or Register to earn points"*.
3. **Center FAB: Camera (`PImgUploadAGuestWidget`)**:
   - **Click Path**: Tap the elevated circular green/blue camera button in the center.
   - **Features Available**:
     - Direct launch of the **Guest AI Waste Scanner**.
     - Take a photo with the device camera or pick an image from the gallery.
     - Gemini AI classifies the item into *Biodegradable, Recyclable, Non-Recyclable, or Hazardous*.
     - Instant segregation advice and recycling instructions displayed on-screen.
     - *Note*: Results are not saved to any database record; points are not awarded until an account is registered.
4. **Tab 3: Explore (`PageViewSubFeaturesWidget`)**:
   - **Click Path**: Tap the fourth icon labelled **Explore**.
   - **Features Available**:
     - Browse the three core public sub-features:
       1. **Collection Schedules**: Interactive cards of all barangay streets and scheduled pickup times.
       2. **Conducted Waste Audits**: Audit reports filed across barangay collection zones.
       3. **Community Metrics**: Aggregate counts of verified, flagged, and segregated waste scans.
5. **Tab 4: Sign In (`LandingPageWidget`)**:
   - **Click Path**: Tap the fifth icon labelled **Sign In**.
   - **Features Available**:
     - Instant return to the authentication gateway to register a new account or log in with existing credentials.

---

### 3.3 Accessing Collection Schedules & Street Directories
1. **From Homepage**:
   - Scroll down to the **"Upcoming Collection"** section.
   - Tap the **"View All"** text link or tap directly on the next scheduled pickup card.
   - This opens `PDatesViewAllWidget`, listing all dates in ascending chronological order.
   - Tap any date card to view pickup time windows, assigned collectors, and street names (`PDatesViewOneWidget`).
2. **From Explore Tab**:
   - Tap **Explore** on the bottom bar.
   - Tap the collection schedule list item to open the full schedule table.
   - Tap on the street name badge to open `PStreetViewOneWidget`.

---

### 3.4 Accessing Educational & Research Documentation
1. Navigate to the **Explore** tab (`PageViewSubFeaturesWidget`).
2. Scroll to the **"About EBasura"** section or tap on informational dialogs.
3. Select from:
   - **App Overview**: Opens `PageProfileAboutWidget`.
   - **ADET Project Details**: Opens `PageProfileAboutADETWidget`.
   - **Waste Research & AI Ethics**: Opens `PageProfileAboutResearchWidget`.

---

## 4. Guest Boundaries & Gated Actions

To safeguard data integrity, prevent spam, and maintain accurate leaderboard statistics, the following capabilities are strictly gated behind account authentication:

| Action Attempted | Guest Result | Triggered Gateway / Behavior |
| :--- | :--- | :--- |
| **Saving Scan History** | Blocked | A modal sheet offers *"Create an account to track your scans"*. |
| **Earning Points & Streaks** | Blocked | Points calculation is skipped in `PImgUploadAGuestWidget`. |
| **Submitting Waste Reports** | Blocked | User is redirected to `LandingPageWidget` / `PageSignInWidget`. |
| **Accessing Profile & Settings** | Blocked | Fourth bottom tab displays **Sign In** instead of **Profile**. |
| **Accessing Admin Dashboard** | Forbidden | Route is gated; unauthorized attempts redirect to `/landingPage`. |
| **Participating in Leaderboard** | Read-Only | Guest can inspect public scores but cannot register a ranking. |
