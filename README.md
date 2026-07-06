# ♻️ EBasura (AEBasura)

A smart, gamified waste management and reporting mobile application built with **Flutter**, **Supabase**, and **Google Gemini AI**. 

EBasura empowers community members to report waste, classify items using advanced AI vision models, view garbage collection schedules, and earn points and badges for recycling.

---

## 🌟 Key Features

### 1. 🔍 AI-Powered Waste Classification
- **Smart Scans**: Users can capture or upload images of waste. The app sends these to **Google Gemini** (e.g., `gemini-2.5-flash` or `gemini-flash-latest`) to classify the item in real time.
- **Attributes Detected**:
  - **Validity**: Confirms if the image actually contains waste.
  - **Segregation**: Segregated vs. Non-segregated.
  - **Recyclability**: Recyclable vs. Non-recyclable.
  - **Biodegradability**: Biodegradable vs. Non-biodegradable.
- **Prompt Injection Guard**: Detects and overrides prompt injections embedded in the image text to ensure system integrity.

### 2. 🏆 Gamification (Points & Badges)
- **Points System**: Scans and waste reports submitted by authenticated users award points.
- **Leaderboards**: Ranks community members by total points earned.
- **Badges**: Users earn custom badges (managed by admins) as milestones are reached.

### 3. 📅 Schedule & Street Management
- Users can view upcoming garbage collection schedules for specific streets, including timings and assigned collectors.

### 4. 👥 Role-Based Workflows
- **Guest Users**: Can perform basic scans without logging in.
- **Authenticated Users**: Access personalized dashboards, save scan history, view the leaderboard, earn points/badges, and submit waste reports.
- **Administrators**: Manage streets, schedules, badges, review filtered/flagged images, and view user management statistics.

---

## 🏗️ Architecture & Stack

- **Frontend**: Flutter (3.x stable compatible) styled with FlutterFlow components.
- **Backend & Database**: **Supabase**
  - **Auth**: Email verification, signup/signin, password recovery.
  - **Tables**:
    - `User`: Basic credentials and user metadata.
    - `User Subtable`: Points, badge reference, notification preferences.
    - `Image`: Metadata for uploaded images (uploader, street reference, classification results, status).
    - `Report`: Trash reporting logs (conducted dates, street location, description).
    - `Collection`: Garbage collection schedules (days, times, assigned collectors).
    - `Street`: Registered community streets.
    - `Badge`: Badges list.
  - **Storage**: Supabase storage bucket for hosting uploaded waste images.
- **AI Engine**: Gemini REST API requests for image analysis and filtering.

---

## ⚙️ Getting Started & Setup

This project uses compile-time environment variables to manage sensitive API keys and URLs.

### 1. Configure Environment Variables
Copy the template environment file:
```bash
cp env.json.example env.json
```
Edit the newly created `env.json` and insert your credentials:
```json
{
  "SUPABASE_URL": "https://clbgdlxkxvjsvcdnvsri.supabase.co",
  "SUPABASE_ANON_KEY": "your_supabase_anon_key",
  "GEMINI_API_KEY": "your_global_gemini_api_key",
  "GEMINI_API_KEY_SCAN_AUTHENTICATED_USER": "",
  "GEMINI_API_KEY_GUEST_SCAN": "",
  "GEMINI_API_KEY_AUTH_SCAN": "",
  "GEMINI_API_KEY_REVALIDATION_SCAN": "",
  "GEMINI_API_KEY_DEV": ""
}
```

*Note: `env.json` is configured in `.gitignore` and will never be pushed to version control.*

### 2. Run the App
Run the app locally with the configured environment variables:
```bash
flutter run --dart-define-from-file=env.json
```

### 3. Build the App
To build the production APK or bundle:
```bash
flutter build apk --dart-define-from-file=env.json
```

---

## 📁 Directory Structure

```text
lib/
├── admin/                 # Admin dashboards, scheduling, badges, user management
├── auth/                  # Supabase authentication helper utilities
├── auth_entry_pages/      # Sign in, Sign up, Forgot password, Onboarding
├── backend/               # Supabase database/table integrations & API calls
├── components/            # Shared UI components (navigation, dialogues, state indicators)
├── custom_code/           # Custom actions, widgets, and files
├── image/                 # Image uploads, history views, and AI image filtering lists
├── page_homepage/         # User home dashboard
├── page_leaderboard/      # Gamification ranking list
├── page_view_sub_features/# Extended user actions
└── profile/               # User settings, email/password changes, "About" pages
```
