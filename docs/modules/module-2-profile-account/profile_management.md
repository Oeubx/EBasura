# Profile Management & Informational Views

## 1. Scope & Purpose
Specifies user profile presentation, avatar customization, personal gamification progress inspection, and institutional/academic background views.

---

## 2. Component Specifications

### 2.1 User Profile Dashboard (`PageProfileWidget`)
- **Location**: `lib/profile/page_profile/`
- **Route**: `/pageProfile`
- **UI & Data Elements**:
  - Displays user avatar and display name.
  - Summarizes lifetime points balance queried from `user_subtable`.
  - Badges Display: Renders horizontal list of acquired badges from `badge` relation.
  - Recent Activities: Quick access link to personal uploaded scan history (`PImagesViewAllUserWidget`).
  - Action buttons: "Edit Profile", "Account Settings", "About EBasura".

### 2.2 Profile Customization (`PageChangeProfileWidget`)
- **Location**: `lib/profile/page_change_profile/`
- **Route**: `/pageChangeProfile`
- **Capabilities**:
  - Update display name.
  - Upload avatar photo to Supabase storage bucket (`avatars/`).
  - Updates associated row in `user` table.

### 2.3 About Views (`lib/profile/abouts/`)
- **`PageProfileAboutWidget`** (`/pageProfileAbout`): General overview of the EBasura mission, civic waste segregation goals, and contact details.
- **`PageProfileAboutADETWidget`** (`/pageProfileAboutADET`): Academic course documentation, course scope, and system objectives.
- **`PageProfileAboutResearchWidget`** (`/pageProfileAboutResearch`): Technical background detailing Google Gemini AI model research, prompt injection defense, and computer vision classification methodology.
