# Module 6: Waste Reporting & Community Alerts

## 1. Overview
Module 6 enables community members to submit waste incident reports (illegal dumping, overflowing public bins, uncollected waste) with photographic evidence and street location tagging. It also provides tools for viewing, auditing, and managing reported incidents.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M6-F0` | Community Waste Incident Submission | Active | `lib/admin/report/c_report_creation/` | [`incident_reporting.md`](incident_reporting.md) |
| `EBASURA-M6-F1` | Reports Directory & Feed | Active | `lib/admin/report/p_report_view_all/` | [`report_management.md`](report_management.md) |
| `EBASURA-M6-F2` | Single Report Details & Location Inspection | Active | `lib/admin/report/p_report_view_one/` | [`report_management.md`](report_management.md) |
| `EBASURA-M6-F3` | Incident Attached Photos Viewer | Active | `lib/admin/report/c_report_view_images/` | [`incident_reporting.md`](incident_reporting.md) |
| `EBASURA-M6-F4` | Incident Report Deletion & Resolution | Active | `lib/admin/report/c_report_deletion/` | [`report_management.md`](report_management.md) |

---

## 3. Submodule Directory

- **[`incident_reporting.md`](incident_reporting.md)**: Specifications for creating incident reports, capturing on-site photos, selecting target streets, and writing incident descriptions.
- **[`report_management.md`](report_management.md)**: Specifications for browsing active incident reports, viewing detail cards, photo carousels, and executing report resolution or deletion.
