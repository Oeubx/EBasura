# Module 3: AI Waste Scanning & Classification

## 1. Overview
Module 3 contains the AI computer vision engine of EBasura. By utilizing the Google Gemini REST API (`gemini-2.5-flash` and `gemini-flash-latest`), images captured via device camera or gallery are analyzed in real time to classify waste characteristics, prevent prompt injections, and award user points.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M3-F0` | Gemini REST Client & Payload Serializer | Active | `lib/backend/api_requests/api_calls.dart` | [`gemini_api_integration.md`](gemini_api_integration.md) |
| `EBASURA-M3-F1` | Authenticated User Waste Scanner | Active | `lib/image/image_uploads/p_img_upload_a_auth/` | [`gemini_api_integration.md`](gemini_api_integration.md) |
| `EBASURA-M3-F2` | Guest Waste Scanner Flow | Active | `lib/image/image_uploads/p_img_upload_a_guest/` | [`gemini_api_integration.md`](gemini_api_integration.md) |
| `EBASURA-M3-F3` | 5-Attribute Classification Evaluator | Active | `api_calls.dart` (`ScanapibyauthenticatedUserCall`) | [`classification_and_injection_guard.md`](classification_and_injection_guard.md) |
| `EBASURA-M3-F4` | Visual Prompt Injection Guard | Active | `api_calls.dart` (`instructionPrompt`) | [`classification_and_injection_guard.md`](classification_and_injection_guard.md) |
| `EBASURA-M3-F5` | Scan Revalidation & Dev Pipeline | Active | `RevalidationScanCall`, `DevCall` | [`gemini_api_integration.md`](gemini_api_integration.md) |

---

## 3. Submodule Directory

- **[`gemini_api_integration.md`](gemini_api_integration.md)**: Specifications for Google Gemini REST endpoints, base64 payload serialization, API key scoping, and network request life cycles.
- **[`classification_and_injection_guard.md`](classification_and_injection_guard.md)**: Rules, prompts, and classification parsing for valid waste, recyclability, segregation, biodegradability, and adversarial text injection mitigation.
- **[`optimizations.md`](optimizations.md)**: Architectural modernization specifications, deterministic JSON schema outputs, client-side downscaling/compression, and API service unification.
- **[`EBASURA_IMAGE_SCANNING_PROCESS.md`](../../EBASURA_IMAGE_SCANNING_PROCESS.md)**: Comprehensive end-to-end specification covering media acquisition, Gemini multimodal evaluation, injection defenses, and persistence.
- **[`EBASURA_AI_IMAGE_SCANNING_RULES_AND_HEURISTICS.md`](../../EBASURA_AI_IMAGE_SCANNING_RULES_AND_HEURISTICS.md)**: Consolidated specification of all AI scanning prompt rules, 5-attribute classification heuristics, injection defense, and client parsing.

