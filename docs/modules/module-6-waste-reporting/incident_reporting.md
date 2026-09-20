# Incident Reporting & Photo Attachment Workflow

## 1. Scope & Responsibility
Specifies the submission interface, input parameters, and image attachments required when reporting waste infractions or hazards.

---

## 2. Submission Component (`CReportCreationWidget`)
- **Location**: `lib/admin/report/c_report_creation/`
- **Fields**:
  - `incidentDate`: Date picker selecting the occurrence date.
  - `streetRef`: Dropdown querying active community streets from `street` table.
  - `description`: Text field detailing the issue (e.g., *"Large pile of unsegregated plastic bags left near drainage"*).
  - `photoUpload`: Camera/gallery picker capturing photo evidence, uploaded to `report_images/` bucket.
- **Data Validation**:
  - Prohibits empty descriptions.
  - Requires street selection to ensure collector routing.
  - Requires at least one photographic proof.

---

## 3. Photo Viewer Modal (`CReportViewImagesWidget`)
- **Location**: `lib/admin/report/c_report_view_images/`
- **Capabilities**:
  - Full-screen high-resolution zoom viewer for images attached to a report.
  - Swipe carousel support for multiple photo submissions.
