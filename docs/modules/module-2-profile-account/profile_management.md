# Profile Management & Informational Views

## 1. Scope & Purpose
Specifies user profile presentation, avatar customization, personal gamification progress inspection, resident waste incident reporting, and institutional/academic background views.

---

## 2. Component Specifications

### 2.1 User Profile Dashboard (`PageProfileWidget`)
- **Location**: [`lib/profile/page_profile/page_profile_widget.dart`](file:///c:/BiboyStuffs/EBasura/lib/profile/page_profile/page_profile_widget.dart)
- **Route**: `/pageProfile`
- **UI & Data Elements**:
  - Displays user avatar and display name.
  - Summarizes lifetime points balance queried from `user_subtable`.
  - Badges Display: Renders horizontal list of acquired badges from `badge` relation.
  - Recent Activities: Quick access link to personal uploaded scan history ([`PImagesViewAllUserWidget`](file:///c:/BiboyStuffs/EBasura/lib/image/image_views/p_images_view_all_user/p_images_view_all_user_widget.dart)).
  - **Resident Waste Incident Reporting Section**:
    - Embedded card allowing community members to file reports with subject, street selection, description, and photo proof.
    - Persisted into Supabase `Report` table with `report_status = 'Pending'`.
    - Features "View All" link directing to [`PReportViewAllWidget`](file:///c:/BiboyStuffs/EBasura/lib/admin/report/p_report_view_all/p_report_view_all_widget.dart).
  - Action buttons: "My Uploads", "Settings", and "Sign Out".

### 2.2 Profile Customization (`PageChangeProfileWidget`)
- **Location**: [`lib/profile/page_change_profile/page_change_profile_widget.dart`](file:///c:/BiboyStuffs/EBasura/lib/profile/page_change_profile/page_change_profile_widget.dart)
- **Route**: `/pageChangeProfile`
- **Capabilities**:
  - Update display name.
  - Upload avatar photo to Supabase storage bucket (`Image_Bucket/Avatars/`).
  - Updates associated row in `user` table.

### 2.3 About Views (`lib/profile/abouts/`)
- **`PageProfileAboutWidget`** (`/pageProfileAbout`): General overview of the EBasura mission, civic waste segregation goals, and contact details.
- **`PageProfileAboutADETWidget`** (`/pageProfileAboutADET`): Academic course documentation, course scope, and system objectives.
- **`PageProfileAboutResearchWidget`** (`/pageProfileAboutResearch`): Technical background detailing Google Gemini AI model research, prompt injection defense, and computer vision classification methodology.
