# EBasura Academic Thesis Manuscript (Chapters 1–6)

> **Document Title:** EBasura: An AI-Assisted, Human-Verified Mobile System for Household Waste Segregation Monitoring in Philippine Barangays  
> **Draft Status:** First full draft (v0.1), Chapters 1–6 + Appendix A  
> **Source:** Dev's *Academic Research Paper Document Roadmap* + `docs/` on branch `feat/rd-update` (github.com/Oeubx/EBasura)  
> **Research Methodology:** Design Science Research Methodology (DSRM; Peffers et al., 2007)

---

## 📚 Table of Contents

| File | Chapter / Section | Key Topics & Evidence |
| :--- | :--- | :--- |
| 📄 [`chapter-1-introduction.md`](chapter-1-introduction.md) | **Chapter 1: Introduction** | RA 9003 context, Problem statement, General & specific objectives, Significance, Scope & delimitations, DSRM framework. |
| 📄 [`chapter-2-literature-review.md`](chapter-2-literature-review.md) | **Chapter 2: Review of Related Literature** | Computer vision in waste management, The "Closed Bag" occlusion dilemma, Adversarial visual prompt injection, Human-in-the-Loop (HITL), Gamification. |
| 📄 [`chapter-3-methodology-and-architecture.md`](chapter-3-methodology-and-architecture.md) | **Chapter 3: Methodology & System Architecture** | Research design, System architecture flowchart, Live-camera-only capture, 1024px/80% edge compression, Gemini API integration, Retake guardrails, Evaluation instruments. |
| 📄 [`chapter-4-system-implementation.md`](chapter-4-system-implementation.md) | **Chapter 4: System Implementation** | Role-Based Access Control (RBAC), Master CRUD permissions matrix, Tri-state moderation lifecycle (`chk_image_tri_state_status`), Incident reporting, Dual-column schema (`ai_*` vs `admin_*`). |
| 📄 [`chapter-5-results-and-discussion.md`](chapter-5-results-and-discussion.md) | **Chapter 5: Results & Discussion** | Field trial dataset description template, Confusion matrix, Multi-attribute metrics (Segregated, Recyclable, Biodegradable), Cohen's κ, Desk audit latency, Data export. |
| 📄 [`chapter-6-conclusions-and-recommendations.md`](chapter-6-conclusions-and-recommendations.md) | **Chapter 6: Conclusions & Recommendations** | Civic dispute and recourse (`CDisputeDecisionWidget`), Street Compliance Index (SCI) grading, Sideloaded APK distribution, Recommendations for LGUs and future researchers. |
| 📄 [`appendix-a-doc-conflicts-and-gaps.md`](appendix-a-doc-conflicts-and-gaps.md) | **Appendix A: Doc Conflicts & Gaps** | 15 critical gap notes, verification items, and tracking of resolved vs pending items before oral defense. |
| 📑 [`EBASURA_THESIS_DRAFT_CH1-6.md`](EBASURA_THESIS_DRAFT_CH1-6.md) | **Complete Compiled Draft** | Full monolithic manuscript draft v0.1 in a single unified markdown file. |

---

## 📌 Editorial Conventions Used in Draft

- `[CITE]`: Marks locations where a formal peer-reviewed academic citation must be found and inserted prior to final defense submission.
- `[DATA]`: Denotes placeholder empirical values that will be populated from the physical barangay field trial and exported CSV datasets.
- `(→ docs/...)`: Canonical cross-reference links mapping thesis sections to repository technical specifications.
- **DSRM Traceability**: Backlog tags formatted as `[EBASURA-M#-F#]` map specific software design objectives directly to Git commit hashes.
