# Supabase Client Infrastructure & Environment Configuration

## 1. Scope & Purpose
Documents the database access layer, storage bucket adapters, and secret configuration parameters that power EBasura's backend connectivity.

---

## 2. Environment Configuration (`env.json`)
The client app injects credentials via compile-time `--dart-define-from-file=env.json` or runtime environment lookups.

### Tracked Schema (`env.json.example`):
```json
{
  "SUPABASE_URL": "https://<project-ref>.supabase.co",
  "SUPABASE_ANON_KEY": "<anon-public-jwt>",
  "GEMINI_API_KEY": "<google-ai-api-key>",
  "GEMINI_API_KEY_AUTH_SCAN": "<optional-auth-scoped-key>",
  "GEMINI_API_KEY_GUEST_SCAN": "<optional-guest-scoped-key>",
  "GEMINI_API_KEY_REVALIDATION_SCAN": "<optional-reval-key>",
  "GEMINI_API_KEY_DEV": "<dev-key>"
}
```

### Security Directives:
- `env.json` contains production/staging credentials and **must remain strictly gitignored** (`.gitignore` line 56).
- Never commit hardcoded secret strings into Dart source files or repository commits.

---

## 3. Supabase Client Bootstrap (`lib/backend/supabase/supabase.dart`)
Initialization occurs in `lib/main.dart` prior to invoking `runApp()`:

```dart
await SupaFlow.initialize();
```

Inside `SupaFlow`:
- Instantiates `Supabase.initialize(...)` with `url` and `anonKey`.
- Exposes accessors for authentication (`SupaFlow.client.auth`) and storage (`SupaFlow.client.storage`).

---

## 4. Postgres Table Data Models
Found in `lib/backend/supabase/database/tables/`:
- **`user.dart`**: Core user credentials, auth UUID, role, and creation metadata.
- **`user_subtable.dart`**: Gamification state (points balance, active badge ID, notification settings).
- **`image.dart`**: Uploaded waste images, base64/URL reference, detected AI tags, and moderation status.
- **`report.dart`**: Waste reporting incident logs, geolocation, street reference, and description.
- **`collection.dart`**: Street collection schedules, collector assignments, and timetable.
- **`street.dart`**: Registered community streets and areas.
- **`badge.dart`**: Gamification badges, point thresholds, and icon URLs.

---

## 5. Storage Buckets
Configured via `lib/backend/supabase/storage/storage.dart`:
- Handles multipart binary and Base64 image uploads for waste scans, community reports, and user profile pictures.
