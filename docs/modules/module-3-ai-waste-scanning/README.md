# Module 3: AI Waste Scanning & Image Classification

## 1. Overview
Module 3 implements automated waste characterization, computer vision scanning, and Gemini-powered recyclability classification. It processes user camera captures, verifies image viability, detects multi-modal prompt injection attempts, and parses detailed categorical feedback with eco-point assignments.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M3-F0` | Authenticated Camera Capture & Framing Viewfinder | Active | `lib/image/image_uploads/p_img_upload_a_auth/` | [`gemini_api_integration.md`](gemini_api_integration.md) |
| `EBASURA-M3-F1` | Guest Camera Capture & Local Scanning | Active | `lib/image/image_uploads/p_img_upload_a_guest/` | [`gemini_api_integration.md`](gemini_api_integration.md) |
| `EBASURA-M3-F2` | Gemini REST Classification Client | Active | `lib/backend/gemini/` | [`gemini_api_integration.md`](gemini_api_integration.md) |
| `EBASURA-M3-F3` | Multimodal Prompt Injection Mitigation | Active | `lib/image/image_uploads/p_img_upload_a_auth/` | [`classification_and_injection_guard.md`](classification_and_injection_guard.md) |
| `EBASURA-M3-F4` | Multi-Attribute Heuristic Evaluation Parser | Active | `lib/custom_code/actions/` | [`classification_and_injection_guard.md`](classification_and_injection_guard.md) |
| `EBASURA-M3-F5` | Live Scanning Results Bottom Sheet & Breakdown | Active | `lib/image/image_uploads/p_img_upload_a_auth/` | [`classification_and_injection_guard.md`](classification_and_injection_guard.md) |
| `EBASURA-M3-F6` | Photo Quality Camera Framing Overlay & Retake Guardrail | Active | `lib/image/c_camera_framing_overlay/` | [`../../ai_vision/retake_guardrail_and_dual_schema.md`](../../ai_vision/retake_guardrail_and_dual_schema.md) |

---

## 3. Submodule Directory

- **[`gemini_api_integration.md`](gemini_api_integration.md)**: Specifications for Google Gemini REST endpoints, base64 payload serialization, API key scoping, and network request life cycles.
- **[`classification_and_injection_guard.md`](classification_and_injection_guard.md)**: Rules, prompts, and classification parsing for valid waste, recyclability, segregation, biodegradability, and adversarial text injection mitigation.
- **[`optimizations.md`](optimizations.md)**: Architectural modernization specifications, deterministic JSON schema outputs, client-side downscaling/compression, and API service unification.
- **[`scanning_process_workflow.md`](../../ai_vision/scanning_process_workflow.md)**: Comprehensive end-to-end specification covering media acquisition, Gemini multimodal evaluation, injection defenses, and persistence.
- **[`scanning_rules_and_heuristics.md`](../../ai_vision/scanning_rules_and_heuristics.md)**: Consolidated specification of all AI scanning prompt rules, 5-attribute classification heuristics, injection defense, and client parsing.
