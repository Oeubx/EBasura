# Incident Report Management & Resolution

## 1. Scope & Responsibility
Specifies the management screens, list filters, detail inspection, and deletion workflows for waste incident reports.

---

## 2. Component Specifications

### 2.1 Reports Directory (`PReportViewAllWidget`)
- **Location**: `lib/admin/report/p_report_view_all/`
- **Route**: `/pReportViewAll`
- **Capabilities**:
  - Displays paginated list of all active waste reports queried from `report` table.
  - Card summaries display: street name, date of incident, short preview of description, thumbnail proof, and status badge.
  - Tapping a report navigates to `PReportViewOneWidget`.

### 2.2 Report Detail View (`PReportViewOneWidget`)
- **Location**: `lib/admin/report/p_report_view_one/`
- **Route**: `/pReportViewOne`
- **Parameters**: `reportRef` (`ReportRow` Supabase reference).
- **Capabilities**:
  - Complete description and full metadata.
  - Full-resolution photo gallery triggers via `CReportViewImagesWidget`.
  - Action trigger to mark as resolved or trigger report deletion (`CReportDeletionWidget`).

### 2.3 Report Deletion Modal (`CReportDeletionWidget`)
- **Location**: `lib/admin/report/c_report_deletion/`
- **Permissions**: Report author or administrator.
- **Workflow**:
  - Prompts confirmation.
  - Cascades deletion of associated photo files from Supabase Storage.
  - Removes row from `report` table.
