# Module 9 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Administrator Operations & User Management
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-9-administrator-operations--user-management-ebasura-m9-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-9-administrator-operations--user-management-ebasura-m9-f)
- **Primary Feature Codes**: `[EBASURA-M9-F0]`, `[EBASURA-M9-F1]`, `[EBASURA-M9-F2]`, `[EBASURA-M9-F3]`, `[EBASURA-M9-F4]`, `[EBASURA-M9-F5]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M9-F0` | Admin Dashboard Metrics | Static navigation tiles without live aggregate platform metrics. | Summary cards displaying live metrics (Total Scans, Segregation %, Unresolved Reports, Active Users). |
| `EBASURA-M9-F5` | Flagged Moderation Queue | Admins inspect flagged/adversarial images one-by-one with full screen transitions. | Batch moderation tool with multi-select checkboxes for quick bulk verification or deletion. |
| `EBASURA-M9-F1` | User Management Auditing | Table displays all users in a single unpaginated stream without search or role filters. | Paginated user management table with search by username/email, role filtering, and points adjustment logs. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Bulk Moderation Efficiency (`EBASURA-M9-F5`)
- **Root Cause**:
  In `p_images_view_all_flagged`, community verifiers and administrators had to click into each individual image card, wait for `PImgViewVerifierWidget` to load, tap a button, and navigate back. For high-volume days with dozens of flagged scans, this workflow was impractically slow.
- **Optimization Strategy**:
  Introduce a multi-select mode in `PImagesViewAllWidget` when opened by an admin/verifier. Admins can select multiple image cards and execute bulk actions (`Verify Selected`, `Flag Selected`, `Delete Selected`) in a single batch transaction.

### 2.2 Dashboard Key Performance Indicators (`EBASURA-M9-F0`)
- **Root Cause**:
  `PageAdminDashboardWidget` functioned merely as an icon launcher menu, offering no high-level visibility into barangay waste management performance.
- **Optimization Strategy**:
  Aggregate key statistics via Postgres count queries to provide immediate insight into daily participation, segregation compliance percentage, and open hazards needing resolution.
