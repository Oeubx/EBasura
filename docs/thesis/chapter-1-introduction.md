# CHAPTER 1 — INTRODUCTION

## 1.1 Background of the Study
*(→ [`docs/modules/OPTIMIZATIONS_INDEX.md`](../modules/OPTIMIZATIONS_INDEX.md))*

Solid waste management (SWM) is still a persistent governance problem for Philippine local government units (LGUs). Republic Act No. 9003, the *Ecological Solid Waste Management Act of 2000*, requires waste to be segregated at source. It also gives barangays responsibility for collecting segregated biodegradable, compostable, and reusable waste. In practice, however, checking whether households comply depends on manual inspection. Collection crews or barangay personnel have to look at bags at the roadside or go door to door. This is slow and inconsistent, and it leaves no record that can be audited. As a result, barangays have little spatial or historical data on which streets regularly fail to segregate. They also cannot easily track where roadside dumping hot-spots form. `[CITE: local SWM compliance study / DENR-EMB report]`

Multimodal Large Language Models (MLLMs) are now widely available. Google's Gemini family, for example, can classify an image from a natural-language prompt without task-specific training. This makes it possible to move the first round of inspection from the street to a phone camera. The AI result then becomes a *preliminary* label that a human official confirms at a desk, which takes seconds instead of a physical visit.

EBasura is a Flutter mobile application with a Supabase (PostgreSQL) back end. The system is organized into 11 modules (Module 0–10), which cover core architecture, authentication, profiles, AI scanning, moderation, gamification, incident reporting, collection schedules, the street directory, administrator operations, and shared navigation.

---

## 1.2 Statement of the Problem
*(→ [`docs/modules/module-6-waste-reporting/README.md`](../modules/module-6-waste-reporting/README.md))*

**General problem:** Barangays have no fast, auditable, data-producing way to check household waste segregation and respond to residents' waste reports.

**Specific problems:**
1. Physically inspecting waste bags door to door takes too much labor, gives inconsistent results, and leaves no verifiable record.
2. There is a delay between a resident seeing a waste hazard and the collection crew being sent, because there is no structured reporting channel.
3. Fully automated AI classification cannot be relied on by itself. Closed opaque bags show only their top layer, and adversarial images can manipulate the model.
4. Residents have little incentive to segregate consistently or to take part in reporting.

---

## 1.3 Objectives of the Study

**General objective:** To design, develop, and evaluate EBasura, an AI-assisted, human-verified mobile system that classifies household waste segregation from live photographs and supports barangay-level verification, reporting, and civic participation.

**Specific objectives:**
1. Build a live-camera-only capture pipeline that classifies waste on five attributes (valid waste, recyclable, segregated, biodegradable, non-biodegradable) using a multimodal LLM.
2. Add safeguards against unreliable or adversarial inputs: a 3-attempt retake guardrail and a visual prompt-injection guard.
3. Implement a Human-in-the-Loop (HITL) moderation workflow (Non-Verified → Verified / Flagged) that stores AI predictions and human decisions in separate columns.
4. Provide role-based access for Guests, Residents, Collection Crew, and Administrators.
5. Evaluate the AI against human ground truth using accuracy, precision, recall, F1-score, and Cohen's κ, and measure how long desk audits take.
6. Add a gamification layer (points, leaderboard, badges) and a street-level compliance view to encourage participation.

---

## 1.4 Significance of the Study
- **Barangay officials / LGUs:** Each photo takes a few seconds to check at a desk instead of a physical visit, and every decision leaves an audit trail.
- **Collection crews:** Less time spent inspecting bags at the roadside, and a structured channel for reporting incidents.
- **Residents:** A transparent record of their own compliance, a way to appeal (dispute), and recognition through gamification.
- **Researchers:** A reusable dual-column dataset design for evaluating MLLMs in public-service settings.

---

## 1.5 Scope and Delimitations
*(→ [`docs/access_control/README.md`](../access_control/README.md))*

**Scope**
- Android only, distributed as a sideloaded APK (minSdk 23 / Android 6.0).
- Four roles: **Guest** (anonymous scanning, no points), **Resident** (scans, points, disputes, incident reports), **Collection Crew** (routes, pickups, field reports), **Administrator** (moderation, verification, user and schedule management).
- AI classification uses Google Gemini (`gemini-2.5-flash`, `gemini-flash-latest`) through REST.
- Waste is classified into five binary attributes. It is not identified at the level of individual objects.

**Delimitations**
- The AI judges only what is **visible**. For a closed bag, that is the top layer or outer surface. Results are treated as a sample, never as a full characterization of the contents.
- AI output is **never final**. Only administrator-verified records count as official.
- The study does not train a custom model. It evaluates a general-purpose MLLM used zero-shot.
- iOS, offline classification, and integration with LGU systems outside the app are out of scope.
- The field trial covers `[DATA: barangay name, number of streets, trial period]`.

---

## 1.6 Definition of Terms
| Term | Operational definition |
| :--- | :--- |
| **Segregated** | Waste in a bag or container belongs to a single stream (or is properly separated), as judged from the photo. |
| **Non-Verified / Verified / Flagged** | The three moderation states of an uploaded image. |
| **Ground truth** | The administrator's final classification of an image (`admin_classification`). |
| **HITL** | Human-in-the-Loop: a design where AI output is reviewed by a human before it takes effect. |
| **Retake guardrail** | A limit of 3 failed scan attempts per capture session. |
| **Prompt injection (visual)** | Text placed in an image to manipulate the model's output. |

---

## 1.7 Research Framework: Design Science Research Methodology
*(→ [`docs/backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md))*

The study follows the Design Science Research Methodology (DSRM) of Peffers et al. (2007). It has six activities: (1) identify the problem, (2) define the objectives, (3) design and develop, (4) demonstrate, (5) evaluate, and (6) communicate. The artifact is EBasura itself. Each design objective is traced to a sprint backlog code in the form `[EBASURA-M#-F#]` (module, feature), and every commit is tagged with its code. This gives a 1:1 audit trail from requirement to implementation, which is an important source of rigor in DSR (Hevner et al., 2004).

| DSRM activity | EBasura evidence |
| :--- | :--- |
| Problem identification | Chapter 1; RA 9003 compliance gap |
| Objectives | §1.3; backlog catalog M0–M10 |
| Design & development | Chapters 3–4; tagged commits |
| Demonstration | Field trial `[DATA]` |
| Evaluation | Chapter 5 (confusion matrix, κ, latency, tests) |
| Communication | This manuscript; `docs/` |
