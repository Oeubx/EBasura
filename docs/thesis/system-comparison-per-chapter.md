# EBasura: System Comparison per Chapter

[← Thesis Index](README.md) | [Chapter 1](chapter-1-introduction.md) | [Chapter 2](chapter-2-literature-review.md) | [Chapter 3](chapter-3-methodology-and-architecture.md) | [Chapter 4](chapter-4-system-implementation.md) | [Chapter 5](chapter-5-results-and-discussion.md) | [Chapter 6](chapter-6-conclusions-and-recommendations.md)

---

> **Purpose:** This reference document provides an academic and technical comparative benchmark between **EBasura** and competing paradigms across each chapter of the Design Science Research manuscript. It equips researchers, evaluators, and defense panelists with a structured contrast between the proposed artifact and existing solid waste management (SWM) solutions.

---

## Comparative System Archetypes

To establish rigorous benchmarks, EBasura is evaluated against four established archetypes:

1. **Archetype A — Traditional Manual Inspection (Status Quo):** Door-to-door physical waste bag checks and roadside spot inspections by barangay environmental police/crews using paper logs.
2. **Archetype B — IoT Smart Bins & Automated Sorters:** Hardware-intensive bins with embedded edge cameras, ultrasonic fullness sensors, and pneumatic/mechanical sorting gates (e.g., CleanCUBE, TrashBot).
3. **Archetype C — Pure Civic Crowdsourcing Apps:** Mobile reporting tools allowing citizens to upload photos of waste piles without AI classification (e.g., CleanSpot, FixMyStreet).
4. **Archetype D — Autonomous Vision AI Systems:** Purely automated deep learning/CNN classifiers that make binding segregation or fine determinations without human oversight.
5. **Proposed System — EBasura:** AI-assisted, human-in-the-loop (HITL) mobile platform utilizing zero-shot multimodal LLMs, live-camera anti-spoofing, dual-schema desk audits, citizen recourse, and street-level compliance grading.

---

## Chapter 1: Introduction, Problem Scope & Governance

### Paradigm Comparison

| Dimension | Archetype A: Manual Door-to-Door | Archetype B: IoT Smart Bins | Archetype C: Crowdsource Apps | Archetype D: Autonomous AI | **Proposed: EBasura** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **RA 9003 Alignment** | Mandated by law, but hindered by severe manpower shortages. | Confined to indoor commercial spaces; infeasible across rural puroks. | Focuses only on open dumping; ignores household source segregation. | Violates due process if fully automated penalties are imposed. | **Directly operationalizes household source segregation with legal due process.** |
| **Operational Labor** | High physical burden; requires patrol teams walking daily routes. | Requires high maintenance, emptying, sensor calibration. | Low municipal labor; passive resident submission. | Zero human labor post-deployment. | **Low desk-audit labor; verification takes seconds per photo from a municipal desk.** |
| **Capital Expenditure** | Zero initial hardware cost; high recurring personnel expense. | Prohibitive (\$1,500–\$5,000 per bin); impractical for barangays. | Low software hosting costs; no automated analysis. | High GPU cloud or on-prem server infrastructure costs. | **Minimal cost; operates on existing resident and staff Android smartphones.** |
| **Spatial & Temporal Auditability** | None; paper records are lost, delayed, or lack photographic evidence. | Real-time bin telemetry; lacks household-level attribution. | Spatial incident logs; lacks residential segregation tracking. | Digital database logs; lacks verifiable human ground truth. | **Immutable relational audit trail: geo-tagged, time-stamped, and dual-classified.** |

### Key Chapter 1 Defense Takeaway
> While traditional manual inspections cannot scale to thousands of households and IoT bins are financially impossible for Philippine barangays, EBasura utilizes ubiquitous mobile devices to achieve household-level RA 9003 monitoring at negligible capital expenditure.

---

## Chapter 2: Literature Review, AI Models & Behavioral Theory

### Technical & Algorithmic Comparison

| Technical Theme | Archetype A: Manual Inspection | Archetype B: Dedicated Edge CNNs | Archetype C: Pure Crowdsourcing | Archetype D: Autonomous MLLM | **Proposed: EBasura** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Computer Vision Approach** | Human ocular inspection only. | Custom CNN/YOLO trained on curated single-object datasets (TrashNet). | No computer vision; human moderators manually read every ticket. | Zero-shot MLLM (GPT-4V / Gemini) acting as sole judge. | **Zero-shot MLLM (`gemini-flash`) paired with a Human-in-the-Loop desk verifier.** |
| **Dataset & Retraining Overhead** | None. | High; must annotate thousands of images whenever packaging changes. | None. | None; relies on general pretraining. | **Zero dataset retraining required; adapts zero-shot across varied Philippine packaging.** |
| **Occlusion ("Closed Bag") Handling** | Officers can physically tear open bags (unhygienic, biohazard). | Fails completely on closed bags; assumes single unoccluded object. | Manual moderator guesses or rejects ticket. | Produces high-confidence hallucinations on invisible contents. | **Formalized design delimitation: evaluates visible layer, backed by retake guardrails.** |
| **Adversarial Prompt Injection Defense** | Not applicable. | Robust against prompt injection; vulnerable to physical camouflage. | Not applicable (human review). | Completely vulnerable to embedded text/signs altering outputs. | **Dual defense: structured system prompt quarantine + mandatory human desk verification.** |
| **Gamification & Behavioral Incentives** | Verbal warnings or paper citations; no positive reinforcement. | Audio cues or screen thank-you notes at the bin. | Badges for reporting trash piles; no household rewards. | Automated points subject to gaming and prompt injection hacks. | **Tamper-resistant gamification: points awarded strictly upon human admin approval.** |

### Key Chapter 2 Defense Takeaway
> Off-the-shelf CNNs fail in complex, cluttered household scenes, while autonomous MLLMs are vulnerable to hallucinations and prompt injection. EBasura resolves this by treating the MLLM as an advisory pre-screener within a Human-in-the-Loop framework.

---

## Chapter 3: Methodology, Pipeline & Edge Constraints

### Capture & Network Comparison

| Pipeline Component | Archetype A: Physical Check | Archetype B: Smart Bins | Archetype C: Civic Apps | Archetype D: Autonomous Web AI | **Proposed: EBasura** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Anti-Spoofing Control** | Direct physical observation. | Enclosed mechanical chamber prevents foreign camera injection. | Allows gallery photo picker; vulnerable to web-downloaded spoofing. | Web endpoints commonly permit arbitrary file uploads. | **Live-camera enforcement (`ImageSource.camera`); gallery disabled; frame guidance.** |
| **Network & Bandwidth Optimization** | No digital transmission. | Cellular/LoRaWAN sensor telemetry; high-res camera uploads. | Full-resolution uploads; fails or stalls on poor 3G/LTE connections. | Raw 12MP+ payload uploads; causes high API latency and cost. | **Edge compression: 1024px maximum dimension at 80% JPEG quality (< 300 KB).** |
| **Capture Failure Handling** | Verbal instruction to open bag. | Mechanical jam or reject chute. | Silent submission failure or manual support email. | Indefinite reprocessing or unhandled model exceptions. | **Client-side retake guardrail: max 3 attempts before fallback to `Unclassified`.** |
| **API Contract & Schema** | Paper forms. | Proprietary embedded microcontroller protocols. | Standard multipart form data (text + image). | Unstructured natural language model outputs. | **Strict JSON Schema enforcing 5 binary attributes and injection containment.** |

### Key Chapter 3 Defense Takeaway
> EBasura prevents digital fraud at the glass by locking down image acquisition to live cameras and compresses payloads on-device to survive real-world Philippine cellular bandwidth constraints.

---

## Chapter 4: System Implementation & Data Architecture

### Architecture & Security Comparison

| Architectural Feature | Archetype A: Paper Records | Archetype B: IoT Cloud Platforms | Archetype C: Standard Web Portal | Archetype D: Direct AI Backend | **Proposed: EBasura** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Access Control (RBAC)** | Informal hierarchy; keys to physical filing cabinets. | Device-level API keys; centralized vendor dashboard. | Single-tier user login vs. general admin dashboard. | Public or single-tier API access; no operational roles. | **4-tier granular RBAC (`resident`, `verifier`, `collector`, `admin`) via Supabase RLS.** |
| **Moderation State Topology** | Binary (pass/fail noted on paper). | Binary (accepted into chute / rejected). | Binary or custom (open / in progress / closed). | Binary single-pass classification. | **Formal Tri-State Lifecycle (`Approved`, `Flagged`, `Rejected`) with DB constraints.** |
| **Ground Truth Schema** | Single scribbled note. | Sensor reading log. | Single moderator status field. | Overwrites prediction or stores only model output. | **Dual-column decoupled schema: preserves original `ai_*` alongside `admin_*` decisions.** |
| **Incident Management** | In-person walk-ins to barangay hall. | Automated maintenance tickets for bin servicing. | Geo-tagged pin on public map. | Automated detection from street cameras (expensive). | **Integrated civic incident reporting with camera verification and collector dispatch.** |

### Key Chapter 4 Defense Takeaway
> By decoupling `ai_*` predictions from `admin_*` judgments in a dual-column schema, EBasura prevents data corruption, provides complete auditability, and continuously builds an empirical evaluation corpus during daily operations.

---

## Chapter 5: Results, Reliability & Latency Profiles

### Empirical Performance Comparison

| Evaluation Metric | Archetype A: Manual Inspection | Archetype B: Edge Object Detection | Archetype C: Manual Crowdsourcing | Archetype D: Autonomous MLLM | **Proposed: EBasura** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Verification Speed** | 3–10 minutes per household door-to-door visit. | Real-time sensor trigger (< 1 s); frequent mechanical stall. | 1–3 business days for city engineer ticket triage. | 1–3 seconds API inference time. | **Desk audit takes seconds: verifiers confirm or override AI pre-classifications instantly.** |
| **Reliability Validation** | Unmeasured; high inter-observer variability between officers. | Standard mAP on isolated benchmark datasets. | Subjective moderator discretion; no statistical reliability metric. | Single-rater accuracy; no ground truth validation during runtime. | **Formal Inter-Rater Reliability measured via Cohen's kappa ($\kappa$) (AI vs. Admin).** |
| **Evaluation Breadth** | Overall subjective pass/fail. | Single bounding box detection (e.g., "plastic bottle"). | Free-text narrative inspection. | Unstructured natural language assessment. | **Multi-attribute binary classification: Segregated, Recyclable, Biodegradable.** |
| **Software Quality Verification** | Not applicable. | Hardware bench testing; proprietary firmware tests. | Basic web integration tests. | Prompt engineering spot checks. | **82 passing automated unit/widget tests + 46-case manual role matrix.** |

### Key Chapter 5 Defense Takeaway
> EBasura transforms solid waste auditing from a multi-minute physical chore into an accelerated desk review while measuring agreement using Cohen's kappa to ensure statistical rigor.

---

## Chapter 6: Policy, Recourse, Aggregation & Scalability

### Governance & Deployment Comparison

| Dimension | Archetype A: Traditional Citations | Archetype B: Hardware Deployments | Archetype C: Civic Reporting | Archetype D: Autonomous Penalties | **Proposed: EBasura** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Procedural Fairness & Appeals** | Confrontational verbal arguments on the street. | Inflexible hardware rejection; no mechanism to contest. | Users can leave comment replies on closed tickets. | Algorithmic opacity ("black box" penalty with no human appeal). | **Structured Citizen Recourse: `CDisputeDecisionWidget` (`[DISPUTE - category]: reason`).** |
| **Compliance Aggregation** | Manually compiled monthly summary sheets (prone to delay). | Individual bin fullness metrics; no household neighborhood attribution. | Heatmaps of reported trash piles. | Individual classification logs without street-level synthesis. | **Street Cleanliness Index ($SCI$): Tiered grades (A–D) with $n \ge 10$ scan safeguard.** |
| **Community Impact** | Perceived as punitive harassment by residents. | Viewed as high-tech infrastructure for commercial districts. | Passive; residents only report when public waste accumulates. | High risk of community backlash due to automated false positives. | **Collaborative gamification combining individual incentives with street-level civic pride.** |
| **Software Distribution** | Physical paper distribution. | Custom vendor firmware updates via technicians. | Google Play Store / Apple App Store listing. | Web browser application. | **Standalone Universal APK (~87 MB) distributable offline via USB, Bluetooth, or local drive.** |

### Key Chapter 6 Defense Takeaway
> EBasura avoids the authoritarian pitfalls of autonomous AI by embedding algorithmic due process into every disputed decision, and replaces collective punishment with an evidence-based Street Cleanliness Index ($SCI$).

---

## Master Benchmark Summary Table

| Evaluation Criterion | Traditional Manual (A) | IoT Smart Bins (B) | Crowdsource Portals (C) | Autonomous AI (D) | **EBasura (Proposed)** |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Source Segregation Tracking** | ⚠️ Partial | ❌ None | ❌ None | ⚠️ Risky | ✅ **Comprehensive** |
| **Capital Infrastructure Cost** | ✅ Low | ❌ Extremely High | ✅ Low | ⚠️ Moderate | ✅ **Low (Mobile-Only)** |
| **Per-Household Inspection Time** | ❌ 3–10 mins | ❌ N/A | ❌ Days | ✅ 1–3 secs | ✅ **Accelerated Desk Audit** |
| **Resistance to Digital Spoofing** | ✅ High (Physical) | ✅ High (Chamber) | ❌ Poor (Gallery) | ❌ Poor | ✅ **High (Live-Camera)** |
| **Protection Against Adversarial Prompts**| ✅ Immune | ✅ Immune | ✅ Immune | ❌ Vulnerable | ✅ **Quarantined + HITL** |
| **Legal Due Process & Accountability** | ⚠️ Subjective | ❌ None | ⚠️ Manual | ❌ Violates | ✅ **HITL + Disputes** |
| **Neighborhood-Scale Spatial Analytics**| ❌ None | ⚠️ Point-only | ⚠️ Trash piles | ⚠️ Disconnected | ✅ **Street Registry ($SCI$)**|
| **Deployment Independence** | ✅ Manual | ❌ Vendor lock | ⚠️ Store approval | ⚠️ Cloud dependent| ✅ **Universal APK / Sideload**|

---

[← Thesis Index](README.md) | [Chapter 1](chapter-1-introduction.md) | [Chapter 2](chapter-2-literature-review.md) | [Chapter 3](chapter-3-methodology-and-architecture.md) | [Chapter 4](chapter-4-system-implementation.md) | [Chapter 5](chapter-5-results-and-discussion.md) | [Chapter 6](chapter-6-conclusions-and-recommendations.md)
