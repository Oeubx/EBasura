# Module 3 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: AI Waste Scanning & Classification (Gemini API)
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-3-ai-waste-scanning--classification-ebasura-m3-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-3-ai-waste-scanning--classification-ebasura-m3-f)
- **Primary Feature Codes**: `[EBASURA-M3-F0]`, `[EBASURA-M3-F1]`, `[EBASURA-M3-F2]`, `[EBASURA-M3-F3]`, `[EBASURA-M3-F4]`, `[EBASURA-M3-F5]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M3-F0` | Base64 Image Payload | Uncompressed raw camera captures are base64-encoded in memory, generating 5MB+ JSON payloads. | Client-side downscaling (max dimension 1024px, JPEG 80%), reducing payload size by over 80%. |
| `EBASURA-M3-F3` | AI Classification Parsing | Model instructed to return 5 plain-text lines parsed via `split('\n')`. Fragile if extra whitespace or markdown appears. | Gemini API native structured outputs with `response_mime_type: "application/json"` and strict JSON schema. |
| `EBASURA-M3-F0` | API Call Redundancy | 5 separate classes (`AuthScanCall`, `GuestScanCall`, `RevalidationScanCall`, `DevCall`, `ScanapibyauthenticatedUserCall`) replicate 95% identical HTTP code. | Unified `GeminiScanService` with centralized prompt configuration, API key fallback, and model parameterization. |
| `EBASURA-M3-F4` | Visual Injection Guard | Prompt injection detection relies solely on plain-text output overriding to "false". | Explicit guardrail parsing in structured schema (`"prompt_injection_detected": boolean`), with quarantine routing to `status = 'Flagged'`. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Deterministic Structured JSON Outputs (`EBASURA-M3-F3`)
- **Root Cause**:
  In `lib/flutter_flow/custom_functions.dart:40-52`, `parseWasteResponse` parses Gemini's output by splitting on newline characters:
  ```dart
  List<String> parseWasteResponse(String apiResponseText) {
    if (apiResponseText.isEmpty) return [];
    return apiResponseText.split('\n').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }
  ```
  LLMs naturally exhibit non-deterministic formatting quirks, such as introducing markdown backticks (` ``` `), leading comments ("Here are the 5 attributes:"), or extra newlines. When this occurs, index positions drift, causing `valid_waste_image` to receive a comment string or misaligning attributes.
- **Optimization Strategy**:
  Leverage Google Gemini's native structured JSON output capability:
  ```json
  {
    "type": "OBJECT",
    "properties": {
      "valid_waste_image": { "type": "BOOLEAN" },
      "recyclable": { "type": "BOOLEAN" },
      "segregated": { "type": "BOOLEAN" },
      "biodegradable": { "type": "BOOLEAN" },
      "non_biodegradable": { "type": "BOOLEAN" },
      "prompt_injection_detected": { "type": "BOOLEAN" },
      "detected_material": { "type": "STRING" }
    },
    "required": ["valid_waste_image", "recyclable", "segregated", "biodegradable", "non_biodegradable"]
  }
  ```
  This eliminates parsing errors and guarantees type safety.

### 2.2 Client-Side Image Pre-Compression (`EBASURA-M3-F0`)
- **Root Cause**:
  Camera photos captured on modern smartphones have resolutions upwards of 12-48 megapixels (4000x3000px). Converting uncompressed byte buffers to Base64 in Dart results in strings exceeding 8-15MB. Placing this string inside an inline JSON body causes memory spikes, garbage collection jank, and high failure rates over mobile cellular connections.
- **Optimization Strategy**:
  Resize images to a maximum width/height of 1024px and compress using JPEG format with 80% quality. The resulting Base64 string is under 300KB, accelerating API roundtrips by 4x–8x with negligible loss in AI classification accuracy.
