# Incident Reporting & Photo Attachment Workflow

## 1. Scope & Responsibility
Specifies the submission interfaces, input parameters, Supabase storage bucket attachments, and database security policies governing waste infraction and illegal dumping reporting across community residents, collection crews, and municipal administrators.

---

## 2. Resident Profile Incident Submission (`PageProfileWidget`)

Community residents can submit waste hazard reports directly from their Profile screen without requiring elevated admin permissions.

- **Component Location**: [`lib/profile/page_profile/page_profile_widget.dart`](file:///c:/BiboyStuffs/EBasura/lib/profile/page_profile/page_profile_widget.dart)
- **UI Container**: Styled "Report Waste Incident" card with Comfortaa header.
- **Input Parameters & Field Mappings**:
  - **Subject (`report_subject`)**: Brief descriptive summary of the incident (e.g., *"Uncollected waste on sidewalk"*, *"Illegal dumping near waterway"*).
  - **Street Name Reference (`report_streetNameRef`)**: Dropdown dynamically populated from `StreetTable` active streets, auto-focused or selected by resident.
  - **Description (`report_description`)**: Multi-line details specifying the exact location, estimated volume, and hazard severity.
  - **Photo Proof (`report_image_link`)**: Image picker (live camera capture or device gallery) uploaded directly to Supabase Storage at `Image_Bucket/Reports/<filename>`.
  - **Reporter Reference (`reporter_userRef`)**: Bound automatically to the authenticated session's `currentUserUid`.
  - **Incident Status (`report_status`)**: Defaults to `'Pending'` upon creation.
- **Client-Side Validation**:
  - Validates that subject and description are non-empty.
  - Enforces mandatory street selection for routing and LGU attribution.
  - Validates image upload completion before dispatching table insert.
- **Post-Submission Feedback**:
  - Displays green snackbar notification: *"Incident report submitted successfully."*
  - Automatically resets input controllers and preview thumbnail.
  - Provides a deep link *"View All"* leading to [`PReportViewAllWidget`](file:///c:/BiboyStuffs/EBasura/lib/admin/report/p_report_view_all/p_report_view_all_widget.dart) to track status.

---

## 3. Administrative / Field Crew Modal Submission (`CReportCreationWidget`)

Used by collection crew personnel on active routes and barangay administrators during street inspections.

- **Component Location**: [`lib/admin/report/c_report_creation/c_report_creation_widget.dart`](file:///c:/BiboyStuffs/EBasura/lib/admin/report/c_report_creation/c_report_creation_widget.dart)
- **UI Architecture**: Modal bottom sheet launched via the floating action button on [`PReportViewAllWidget`](file:///c:/BiboyStuffs/EBasura/lib/admin/report/p_report_view_all/p_report_view_all_widget.dart).
- **Parameters**:
  - `incidentDate`: Date-time picker recording the on-site inspection timestamp (`report_conductedDate`).
  - `streetRef`: Street reference dropdown querying `StreetTable`.
  - `description`: Text area detailing roadside hazards or blocked collection points.
  - `photoUpload`: Evidence photo uploaded to `Image_Bucket/Reports/`.

---

## 4. Supabase Database Schema & Row-Level Security (RLS)

### 4.1 Target Table: `"Report"`
```sql
CREATE TABLE IF NOT EXISTS "public"."Report" (
    "report_id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "report_subject" TEXT,
    "report_description" TEXT,
    "report_remarks" TEXT,
    "report_conductedDate" TIMESTAMPTZ DEFAULT NOW(),
    "report_streetNameRef" TEXT NOT NULL,
    "reporter_userRef" UUID REFERENCES auth.users(id),
    "report_image_link" TEXT,
    "report_status" TEXT DEFAULT 'Pending',
    "created_at" TIMESTAMPTZ DEFAULT NOW()
);
```

### 4.2 Row-Level Security Policies
To enable authenticated residents to insert incident reports while preventing spoofing of the reporter identity, the following Postgres RLS policy is enforced:

```sql
ALTER TABLE "public"."Report" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated residents to insert incident reports"
    ON "public"."Report"
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = "reporter_userRef");

CREATE POLICY "Allow public read access to completed reports"
    ON "public"."Report"
    FOR SELECT
    TO authenticated, anon
    USING (true);
```

### 4.3 Supabase Storage Policy
- **Bucket**: `Image_Bucket`
- **Folder Path**: `Reports/`
- Authenticated residents and crew are granted `INSERT` permissions to upload photographic evidence.

---

## 5. Photo Viewer Modal (`CReportViewImagesWidget`)
- **Location**: [`lib/admin/report/c_report_view_images/`](file:///c:/BiboyStuffs/EBasura/lib/admin/report/c_report_view_images/)
- **Capabilities**:
  - Full-screen high-resolution zoom viewer for photographic evidence attached to reports.
  - Supports pinch-to-zoom and pan via `InteractiveViewer`.
