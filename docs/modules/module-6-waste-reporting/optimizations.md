# Module 6 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Waste Reporting & Community Alerts
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-6-waste-reporting--community-alerts-ebasura-m6-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-6-waste-reporting--community-alerts-ebasura-m6-f)
- **Primary Feature Codes**: `[EBASURA-M6-F0]`, `[EBASURA-M6-F1]`, `[EBASURA-M6-F2]`, `[EBASURA-M6-F3]`, `[EBASURA-M6-F4]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M6-F1` | Incident Directory Filtering | Flat chronological list of all reports without status or location filters. | Filter chips for status (`Pending`, `In Progress`, `Resolved`) and street selection dropdown. |
| `EBASURA-M6-F2` | Single Report Inspection | Static layout with unconstrained text causing vertical clipping on long descriptions. | Structured timeline view displaying reporter, timestamp, assigned street, and resolution notes. |
| `EBASURA-M6-F3` | Attached Evidence Viewer | Static thumbnail image without pinch-to-zoom or full-screen inspection. | Interactive full-screen viewer (`InteractiveViewer`) with multi-touch zoom and pan for photographic evidence. |
| `EBASURA-M6-F4` | Incident Resolution Flow | Deletion is the only moderation option; no intermediate "Resolved" lifecycle. | State-driven lifecycle (Pending -> Under Clean-up -> Cleaned / Resolved), preserving historical incident logs. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Hazard Lifecycle vs. Premature Deletion (`EBASURA-M6-F4`)
- **Root Cause**:
  In `lib/admin/report/`, resolving a waste incident required permanently deleting the record from the database. This erased the audit trail and made it impossible to generate community metrics on frequent waste hot-spots or barangay response times.
- **Optimization Strategy**:
  Introduce explicit status flags (`status = 'Resolved'`) with timestamp tracking (`resolved_at`, `resolved_by`). This keeps the community feed clean while retaining spatial records for barangay route optimization.

### 2.2 Photo Evidence Inspection (`EBASURA-M6-F3`)
- **Root Cause**:
  Waste reports require barangay teams and waste collection staff to identify the exact hazard (e.g. hazardous medical waste vs bulky debris). Small static thumbnails made visual inspection difficult on mobile screens.
- **Optimization Strategy**:
  Implement an `InteractiveViewer` modal allowing sanitation supervisors to zoom in on evidence photos before dispatching collection trucks.
