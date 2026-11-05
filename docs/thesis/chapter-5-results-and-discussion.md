# Chapter 5: Results and Discussion

[← Chapter 4: System Implementation](chapter-4-system-implementation.md) | [Thesis Index](README.md) | [Chapter 6: Conclusions and Recommendations →](chapter-6-conclusions-and-recommendations.md)

---

> **Note on Evaluation Data:** All tables below represent empirical evaluation templates. They are designed to be populated directly from the exported CSV dataset (`[EBASURA-M8-F5]`) following the physical barangay field trial.

---

## 5.1 Dataset Description

The empirical dataset is gathered during the active deployment period within the participating barangay partner community. Scans are submitted by residents, processed through the Google Gemini multimodal API, and subsequently audited by assigned barangay desk verifiers.

| Item | Value |
| :--- | :--- |
| Trial period | `[DATA]` |
| Participating residents / streets | `[DATA]` / `[DATA]` |
| Total scans uploaded | `[DATA]` |
| Auto-flagged (injection / invalid / adversarial) | `[DATA]` |
| Manual-inspection fallbacks (3 retakes exhausted) | `[DATA]` |
| Audited by admin / verifier (evaluation set, $N$) | `[DATA]` |

### Data Filtering & Inclusion Criteria
To ensure statistical validity in evaluating the computer vision model:
- Only rows where `verification_status ∈ {'verified', 'corrected'}` **and** `ai_classification ≠ 'Unclassified'` are ingested into the core classification metrics.
- Images flagged as adversarial injection attacks or rejected for non-waste content (e.g., human faces, inappropriate media) are evaluated separately under system robustness rather than classification accuracy.

---

## 5.2 Confusion Matrix and Classification Metrics
*(Cross-reference: `docs/evaluations/developer_updates_evaluation.md`)*

The primary classification objective is binary segregation status:
- **Positive class:** `Segregated`
- **Negative class:** `Unsegregated`
- **Predicted:** `ai_classification`
- **Ground Truth / Actual:** `admin_classification` (human verifier's ground truth)

| | Actual Segregated | Actual Unsegregated |
| :--- | :---: | :---: |
| **AI: Segregated** | True Positive ($TP$) = `[DATA]` | False Positive ($FP$) = `[DATA]` |
| **AI: Unsegregated** | False Negative ($FN$) = `[DATA]` | True Negative ($TN$) = `[DATA]` |

### Performance Formulas

$$\text{Accuracy} = \frac{TP + TN}{TP + TN + FP + FN}$$

$$\text{Precision} = \frac{TP}{TP + FP}$$

$$\text{Recall} = \frac{TP}{TP + FN}$$

$$F_1 = \frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$$

### Multi-Attribute Classification Performance
Because domestic waste items simultaneously exhibit multiple physical and material characteristics under RA 9003, classification is evaluated across four distinct binary dimensions:

| Attribute | Accuracy | Precision | Recall | $F_1$ Score | Support ($N$) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Segregated** | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` |
| **Recyclable** | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` |
| **Biodegradable** | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` |
| **Non-biodegradable** | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` | `[DATA]` |

### Discussion Prompts & Error Analysis
1. **False Positive Analysis:** Is the AI more prone to classifying mixed waste bags as segregated ($FP$), or misidentifying properly segregated bags as unsegregated ($FN$)?
2. **Occlusion & the Closed-Bag Dilemma:** Correlate false positives and negatives with opaque packaging and partial occlusions as identified in §2.2.
3. **Attribute Difficulty:** Contrast accuracy between unambiguous materials (PET plastic bottles, aluminum cans) versus ambiguous organic/inorganic mixtures.

---

## 5.3 Inter-Rater Reliability (Cohen's κ)

To evaluate the degree of agreement between the Gemini multimodal model and the human barangay verifier beyond chance alone, Cohen's kappa ($\kappa$) is computed:

$$\kappa = \frac{p_o - p_e}{1 - p_e}$$

Where:
- $p_o$ represents **observed agreement**: the proportion of waste scans where the AI model's label and the human verifier's label are identical:
  $$p_o = \frac{TP + TN}{TP + TN + FP + FN}$$
- $p_e$ represents **hypothetical chance agreement**: computed from each rater's marginal label frequencies:
  $$p_e = \left(\frac{TP + FP}{N} \cdot \frac{TP + FN}{N}\right) + \left(\frac{FN + TN}{N} \cdot \frac{FP + TN}{N}\right)$$

> *(Methodological Note: Earlier project roadmap drafts colloquially referred to $p_o$ and $p_e$ as "the model" and "the verifiers". In rigorous statistical practice, both $p_o$ and $p_e$ are mathematical functions of the joint distribution across both raters.)*

| Rater Pair | $p_o$ | $p_e$ | $\kappa$ | Interpretation (Landis & Koch, 1977) |
| :--- | :---: | :---: | :---: | :--- |
| **AI vs. Human Admin** | `[DATA]` | `[DATA]` | `[DATA]` | `[Pending field trial]` |
| **Admin 1 vs. Admin 2 (Optional Baseline)** | `[DATA]` | `[DATA]` | `[DATA]` | `[Optional inter-human baseline]` |

### Benchmark Scale (Landis & Koch, 1977)
- $\kappa < 0.00$: Poor agreement (less than chance)
- $0.01 \le \kappa \le 0.20$: Slight agreement
- $0.21 \le \kappa \le 0.40$: Fair agreement
- $0.41 \le \kappa \le 0.60$: Moderate agreement
- $0.61 \le \kappa \le 0.80$: Substantial agreement
- $0.81 \le \kappa \le 1.00$: Almost perfect agreement

---

## 5.4 Desk Audit Latency
*(Cross-reference: `docs/modules/module-4-image-records-moderation/image_views_and_history.md`)*

Desk audit latency measures the human labor required to verify automated AI recommendations. The metric `verification_time_seconds` is recorded automatically in the database, measured continuously from screen initialization (`initState` in `CVerifierInspectionWidget`) until final decision submission.

| Verification Outcome | Mean Latency (s) | Median Latency (s) | Standard Deviation (s) |
| :--- | :---: | :---: | :---: |
| **Verified (Agreement with AI)** | `[DATA]` | `[DATA]` | `[DATA]` |
| **Corrected (Human Overrides AI)** | `[DATA]` | `[DATA]` | `[DATA]` |
| **Rejected (Invalid / Non-Waste)** | `[DATA]` | `[DATA]` | `[DATA]` |
| **Overall (All Decisions)** | `[DATA]` | `[DATA]` | `[DATA]` |

### Baseline Comparison & Administrative Feasibility
- **Speedup Justification:** To defend the hypothesis that an AI-assisted desk audit significantly improves administrative efficiency compared to physical door-to-door barangay inspections, baseline timing must be benchmarked against literature values or manual inspection logs (`[CITE / FIELD DATA]`).
- **Cognitive Engagement Verification:** The empirical difference between `Verified` decisions (single-tap approval) and `Corrected` decisions (requiring manual dropdown reclassification and remarks) serves as proof that verifiers actively review visual evidence rather than systematically rubber-stamping AI predictions.

---

## 5.5 Functional Verification & Software Quality
*(Cross-reference: `docs/access_control/qa_verification_checklist.md`)*

The system's technical soundness is validated across automated test suites, end-to-end role checklists, and adversarial security probes:

| Verification Suite | Target Cases | Passed | Failed | Success Rate |
| :--- | :---: | :---: | :---: | :---: |
| **Automated Unit & Widget Tests** (`test/`) | 82 test cases | 82 | 0 | 100% |
| **Manual QA Role Checklist** (Resident, Verifier, Collector, Admin) | 46 test cases | 46 | 0 | 100% |
| **Prompt-Injection & Adversarial Probes** (Embedded handwritten signs, prompt overrides) | 10 probe trials | `[DATA]` | `[DATA]` | `[DATA]` |

---

## 5.6 Data Export & Reproducibility
*(Cross-reference: `[EBASURA-M8-F5]`)*

All calculations and empirical tables in this chapter are derived from the administrative CSV exporter implemented under `[EBASURA-M8-F5]`. The exporter generates RFC 4180-compliant comma-separated files directly from Supabase query projections:
- Excludes sensitive PII (passwords, auth tokens, device identifiers).
- Includes all dual-schema columns (`ai_*` vs `admin_*`).
- Preserves raw millisecond timestamps and audit latency figures.

The sanitized CSV dataset is preserved in Appendix B of the thesis to facilitate independent academic replication.

---

## 5.7 Summary of Findings

`[To be synthesized following final field data collection:]`
- **Objective 1 (Pipeline Feasibility):** Whether the live-camera-to-Gemini vision pipeline operates within acceptable latency (< 4 seconds) under standard Philippine 4G/LTE mobile connectivity.
- **Objective 2 (Data Integrity):** Efficacy of client-side anti-spoofing and camera restrictions in eliminating synthetic or web-downloaded gallery submissions.
- **Objective 3 (HITL Workflow):** Demonstration that desk audit verification reduces per-household inspection overhead compared to traditional municipal foot patrols.
- **Objective 4 (RBAC Robustness):** Validation that Supabase Row Level Security effectively enforces administrative boundaries across all user roles.
- **Objective 5 (AI Accuracy):** Level of Cohen's $\kappa$ agreement achieved between Google Gemini and designated barangay verifiers under real-world household lighting and packaging conditions.

---

[← Chapter 4: System Implementation](chapter-4-system-implementation.md) | [Thesis Index](README.md) | [Chapter 6: Conclusions and Recommendations →](chapter-6-conclusions-and-recommendations.md)
