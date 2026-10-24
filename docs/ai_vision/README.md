# EBasura AI Vision & Waste Scanning Directory

This directory centralizes all technical specifications, multimodal Gemini prompt rules, vision heuristics, retake guardrails, and lifecycle moderation transitions for waste classification in EBasura.

---

### 1. AI Image Upload Scanning Rules & Heuristics
ðŸ‘‰ **[`scanning_rules_and_heuristics.md`](scanning_rules_and_heuristics.md)**
- Consolidated specification of all AI scanning prompt rules
- 5-attribute classification heuristics (Material, Segregation, Recyclability, Condition, Quality)
- Visual prompt injection defense and multi-modal adversarial guards
- Strict JSON response schema and client parsing fail-safes

---

### 2. End-to-End Image Scanning & Classification Workflow
ðŸ‘‰ **[`scanning_process_workflow.md`](scanning_process_workflow.md)**
- Complete media acquisition lifecycle from camera viewfinder shutter to post-scan resolution
- Device permissions, client-side compression, EXIF handling, and offline fallbacks
- Google Gemini REST API multimodal evaluation pipeline
- Eco-points calculation and daily streak evaluation

---

### 3. Image Category Tri-State Transition Lifecycle
ðŸ‘‰ **[`category_tri_state_transition.md`](category_tri_state_transition.md)**
- Canonical specification for consolidating image classification states into the strict Tri-State model:
  1. **Non-Verified**: Raw AI inference awaiting community or official audit.
  2. **Verified**: Officially confirmed or corrected by verifier/admin.
  3. **Flagged**: Quarantined for prompt injection, fraud, or misclassification appeal.
- Confusion matrix logging and ground-truth verification data structures

---

### 4. Retake Guardrail & Dual-Column Evaluation Schema
ðŸ‘‰ **[`retake_guardrail_and_dual_schema.md`](retake_guardrail_and_dual_schema.md)**
- Shutter retake guardrails detecting blurry, non-waste, or out-of-frame photographs
- Dual-Column Evaluation: Side-by-side comparison of AI inference vs. Ground-Truth Admin overrides
- Verification timer measuring audit latency (`verification_time_seconds`)
