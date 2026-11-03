# Street Registry, Compliance Index (SCI) & Intervention Desk

## 1. Scope & Responsibility
Documents the community street registry, mathematical Street Compliance Index (SCI), 4-week rolling cleanliness scoring engine, automated intervention flagging, and administrative desk workflows.

---

## 2. Street Compliance Index (SCI) Mathematical Model

To provide a rigorous, objective metric of neighborhood waste segregation health without penalizing smaller streets, EBasura computes a weekly Street Compliance Index ($SCI$).

### 2.1 Mathematical Formulation
For a target week starting Monday at 00:00:00 Asia/Manila:

$$SCI_{week} = \max\left(0, \min\left(100, 100 \cdot \frac{S}{V} - 5 \cdot \min(R, 4)\right)\right)$$

Where:
- $V$: Number of admin-verified waste scans on the street during the week.
- $S$: Number of admin-verified scans classified as **Segregated** ($S \le V$).
- $R$: Number of confirmed/resolved community waste incident reports filed on the street during the week.
- **Report Penalty**: Each valid report reduces the index by 5 points, capped at a maximum deduction of 20 points ($\min(R, 4)$).

### 2.2 Minimum Sample Size Guardrail
To prevent statistical distortion from single-upload anomalies (e.g., 1 scan resulting in 100% or 0%):
- **Requirement**: If $V < 5$ verified scans in the target week, $SCI_{week}$ and letter grade evaluate to `NULL` (**Insufficient Data / Evaluating**).
- Prevents premature grade penalties or false positive administrative flags.

### 2.3 4-Week Rolling Cleanliness Index & Letter Grades
Long-term cleanliness trends are evaluated using a 4-week rolling average ($SCI_{4w}$):

| Grade | 4-Week Rolling SCI ($SCI_{4w}$) | Cleanliness Classification | System Action |
| :---: | :---: | :--- | :--- |
| **A** | $\ge 85.0\%$ | High Compliance | Community recognition; Grade A badge on home card. |
| **B** | $70.0\% - 84.9\%$ | Moderate Compliance | Standard collection frequency. |
| **C** | $50.0\% - 69.9\%$ | At Risk / Needs Action | Anonymous resident educational tips displayed on home dashboard. |
| **D** | $< 50.0\%$ | Critical Segregation Failure | **Automated intervention flag** queued into `street_flag`. Spot-check warning on crew routes. |

---

## 3. Database Architecture & Automated Procedures

### 3.1 `street_compliance_snapshot`
Maintains historical weekly cleanliness scores for empirical tracking:
```sql
CREATE TABLE public.street_compliance_snapshot (
    snapshot_id      BIGSERIAL PRIMARY KEY,
    street_ref       TEXT NOT NULL,
    week_start       DATE NOT NULL,
    verified_scans   INT NOT NULL DEFAULT 0,
    segregated_scans INT NOT NULL DEFAULT 0,
    valid_reports    INT NOT NULL DEFAULT 0,
    sci_week         NUMERIC(5,2),
    sci_rolling4     NUMERIC(5,2),
    grade            CHAR(1) NULL,
    computed_at      TIMESTAMPTZ DEFAULT now(),
    UNIQUE (street_ref, week_start)
);
```

### 3.2 `street_flag`
Tracks administrative intervention cases for Grade D streets:
```sql
CREATE TABLE public.street_flag (
    flag_id      BIGSERIAL PRIMARY KEY,
    street_ref   TEXT NOT NULL,
    opened_week  DATE NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'open'
                 CHECK (status IN ('open', 'notified', 'in_followup', 'resolved')),
    action_note  TEXT,
    assigned_to  UUID REFERENCES auth.users(id),
    resolved_at  TIMESTAMPTZ,
    created_at   TIMESTAMPTZ DEFAULT now()
);
```

### 3.3 Automated Computation (`fn_compute_street_compliance`)
- Executed on a scheduled basis or manually via the admin command desk.
- Aggregates verified scans and resolved reports per street.
- Computes weekly SCI, rolling 4-week average, and letter grade.
- Automatically creates an `open` flag in `street_flag` if a street drops to Grade D and lacks an active flag.

---

## 4. Administrative & Field Workflows

### 4.1 Street Compliance Desk (`PStreetComplianceDeskWidget`)
- **Location**: `lib/admin/street/p_street_compliance_desk/`
- **Route**: `/pStreetComplianceDesk`
- **Features**:
  - **KPI Header**: Real-time counts of active streets, Grade D critical zones, and Grade C at-risk streets.
  - **Recompute Now**: Manual 1-click trigger calling `fn_compute_street_compliance`.
  - **Detailed Inspection Sheet**: Drill-down modal showing formula parameters and historical rolling averages.
  - **Intervention Lifecycle**: Admin workflow progressing flags across 4 stages:
    $$\text{Open} \longrightarrow \text{Notified} \longrightarrow \text{In Follow-up} \longrightarrow \text{Resolved}$$
  - **Action Notes**: Free-form audit log documenting field education visits, barangay notices, or crew instructions.
  - **Export Snapshots CSV**: 1-click download of compliance datasets for empirical research.

### 4.2 Resident Home Card (`PageHomepageWidget`)
- Displays resident's registered street cleanliness grade pill.
- For Grade C and D streets, renders an educational advisory box (e.g., *"Tip: Ensure plastics and paper are separated into blue/green bins before morning collection"*).
- Strictly aggregate and anonymous; never names or shames individual households.

### 4.3 Collection Crew Route Markers (`PageCrewDashboardWidget`)
- Flags requiring field inspection display an immediate red warning marker on the collection checklist:
  `⚠️ Spot-Check: Low Segregation Flag`
- Alerts truck crew to inspect roadside bins for contamination prior to compaction.
