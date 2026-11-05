# Chapter 6: Conclusions and Recommendations

[← Chapter 5: Results and Discussion](chapter-5-results-and-discussion.md) | [Thesis Index](README.md) | [Appendix A: Doc Conflicts & Gaps →](appendix-a-doc-conflicts-and-gaps.md)

---

## 6.1 Civic Dispute and Citizen Recourse
*(Cross-reference: `docs/modules/module-4-image-records-moderation/image_views_and_history.md`, `[EBASURA-M4-F7]`)*

A foundational requirement of ethical civic computing is ensuring citizens have an accessible mechanism to contest algorithmic or administrative determinations. In EBasura, when an automated scan is marked as unsegregated or an administrative verifier overrides or rejects a submission, residents can challenge the verdict through the `CDisputeDecisionWidget`.

### Dispute Workflow & Procedural Fairness
1. **Trigger Condition:** Any scan record in the resident's submission history with a non-verified status (`corrected` or `rejected`) displays an active "Dispute Decision" action.
2. **Category Selection:** Residents select a dispute justification from standardized categories:
   - *"AI Misclassification"* (e.g., clear bottle misidentified as unsegregated)
   - *"Verifier Error"* (e.g., incorrect admin override)
   - *"Packaging Occlusion Clarification"* (e.g., biodegradable bag misinterpreted as plastic)
   - *"Other Technical Discrepancy"*
3. **Substantiated Explanation:** The resident must provide a mandatory text explanation of at least 5 characters.
4. **Audit Trail Logging:** The dispute is persisted to the database record's `remark` field with the canonical formatting:
   ```text
   [DISPUTE - category]: resident_provided_explanation
   ```
5. **Re-Audit Escalation:** The record's moderation state is flagged for secondary supervisory review.

Incorporating structured citizen appeals aligns the system with established principles of algorithmic due process and procedural justice `[CITE: Algorithmic Accountability / Administrative Law]`, mitigating resident disenfranchisement and fostering trust in digital municipal governance.

---

## 6.2 Street Cleanliness Index and Compliance Grading
*(Cross-reference: `docs/modules/module-8-street-directory/street_registry.md`, `[EBASURA-M8-F6]`)*

To prevent collective punishment while incentivizing neighborhood-scale cooperation, EBasura computes a localized **Street Cleanliness Index** ($SCI$). The index aggregates verified household scanning behavior alongside confirmed community incident reports.

### Mathematical Formulation

$$\text{SCI}_s = 100 \cdot \left(\frac{N_{\text{verified segregated}, s}}{N_{\text{verified scans}, s}}\right) - w \cdot N_{\text{verified incidents}, s}$$

Where:
- $s$ denotes the specific street or purok registry identifier.
- $N_{\text{verified segregated}, s}$ represents the count of verified scans confirmed as segregated by human verifiers on street $s$.
- $N_{\text{verified scans}, s}$ represents the total volume of audited waste scans on street $s$.
- $N_{\text{verified incidents}, s}$ represents confirmed civic reports (e.g., illegal dumping, unattended piles) logged against street $s$.
- $w$ is an administrative penalty weighting coefficient (default: $w = 2.5$).

### Compliance Grading Tier Matrix

| Tier Grade | SCI Range | Status | Barangay Administrative Action |
| :---: | :---: | :---: | :--- |
| **Grade A** | $\text{SCI} \ge 85$ | Excellent Compliance | Public recognition on community leaderboard; eligibility for purok incentives. |
| **Grade B** | $70 \le \text{SCI} < 85$ | Satisfactory Compliance | Standard scheduled collection; digital reminders sent to registered households. |
| **Grade C** | $50 \le \text{SCI} < 70$ | Needs Improvement | Targeted IEC (Information, Education, and Communication) campaign deployment. |
| **Grade D** | $\text{SCI} < 50$ | **Flagged Non-Compliant** | Mandatory barangay environmental officer on-site inspection and follow-up. |

### Minimum Sample Threshold Guardrail
To prevent small-sample distortion (e.g., a single non-compliant scan failing an entire street with 200 households), a minimum volume threshold of $N_{\text{verified scans}, s} \ge 10$ is strictly required before an active letter grade is assigned. Streets below this threshold are designated as `Pending Baseline Data`.

---

## 6.3 Scalability, Offline Distribution, and Deployment
*(Cross-reference: `docs/releases/README.md`, `[EBASURA-M0-F3]`)*

To address real-world deployment constraints in Philippine local government units—where official Google Play Store developer accounts, credit card billing, and app review delays present significant adoption hurdles—EBasura is compiled as a standalone universal Android Application Package (APK):

- **Binary Footprint:** ~87 MB universal FAT binary containing arm64-v8a, armeabi-v7a, and x86_64 architectures.
- **Verification & Integrity:** Cryptographic SHA-256 hashes are published alongside each release tag to verify APK integrity prior to installation.
- **Offline Sideloading:** Distributed via local USB drives, peer-to-peer Bluetooth sharing, and local government cloud shares.
- **Operational Trade-offs:**
  - *Advantages:* Zero recurring app store listing fees; immediate deployment; independence from foreign billing accounts.
  - *Disadvantages:* Triggers Google Play Protect sideloading warnings requiring manual user override; lack of automatic background updates; larger file size due to combined multi-ABI bundling.

---

## 6.4 Conclusions

The design, implementation, and empirical evaluation of the EBasura mobile system lead to the following conclusions relative to the research objectives:

1. **Integrated AI-Vision Pipeline:** The deployment of Google Gemini's multimodal vision API over client-side camera captures successfully automates preliminary waste segregation and recyclability classification without requiring dedicated on-premise GPU servers.
2. **Client-Side Anti-Spoofing:** Enforcing camera-exclusive capture, viewfinder framing overlays, and device-level image compression eliminates synthetic image submissions and spoofed web downloads, ensuring that records reflect real physical waste.
3. **Human-in-the-Loop Operational Feasibility:** The dual-column database schema (`ai_*` vs `admin_*`) and desk audit interface ensure that algorithmic outputs remain strictly advisory. Human verifiers retain full judicial authority over waste classification and citizen points allocation.
4. **Security and Access Control:** The implementation of Supabase Row Level Security across four distinct user roles enforces strict principle of least privilege, preventing unauthorized record modification or administrative privilege escalation.
5. **Algorithmic Accountability:** The integration of citizen dispute workflows and minimum-sample street grading ensures fair, transparent administrative governance that aligns with Philippine legal frameworks (RA 9003).

---

## 6.5 Recommendations

### For Local Government Units (LGUs) and Barangay Councils
1. **Supporting Evidence Policy:** Formalize municipal guidelines establishing that EBasura records serve as corroborative documentation and educational indicators under RA 9003, rather than the sole automated basis for issuing legal citations or fines.
2. **Verifier Workload Management:** Designate a minimum of one trained barangay verifier per 500 active households, and continuously track desk audit latency to maintain timely citizen feedback.
3. **Educational Intervention:** Prioritize educational barangay assemblies and targeted household flyers for streets designated as Grade C or D before escalating to punitive measures.

### For Future Researchers and Software Engineers
1. **Dynamic Confidence Scoring:** Transition from heuristic classification thresholds to native token probability logprobs or model-generated calibrated confidence metrics.
2. **Cryptographic Geolocation & Server Timestamps:** Integrate signed GNSS/GPS coordinate payloads and database-generated `DEFAULT now()` timestamps to enhance anti-spoofing resilience against manipulated device system clocks.
3. **Sampling-Based Verification:** As historical inter-rater reliability ($\kappa$) demonstrates consistent statistical convergence between AI and human verifiers, investigate statistical sampling workflows (e.g., auditing 20% of scans at random plus all low-confidence predictions) to reduce verifier workload.
4. **Multi-Model Comparative Benchmarks:** Conduct comparative accuracy, inference latency, and API cost benchmarks between Google Gemini, OpenAI GPT-4o Vision, and locally hosted edge models (e.g., YOLOv8 / MobileNet) running directly on edge devices.
5. **Longitudinal Behavioral Studies:** Conduct multi-month longitudinal field research to determine whether gamification incentives (points, badges, leaderboards) maintain high household segregation compliance after the initial novelty phase diminishes.

---

[← Chapter 5: Results and Discussion](chapter-5-results-and-discussion.md) | [Thesis Index](README.md) | [Appendix A: Doc Conflicts & Gaps →](appendix-a-doc-conflicts-and-gaps.md)
