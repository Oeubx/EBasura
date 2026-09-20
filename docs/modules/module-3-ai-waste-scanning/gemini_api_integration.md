# Google Gemini AI API Integration

## 1. Scope & Responsibility
Documents the network infrastructure, payload encoders, and REST configurations used to connect EBasura with Google's Gemini multimodal models.

---

## 2. API Endpoint Architecture
All AI interactions communicate directly with Google Generative AI REST endpoints:

- **Primary Models**:
  - `gemini-2.5-flash`: Used for guest scans and revalidation flows.
  - `gemini-flash-latest`: Used for authenticated user scans and dev pipelines.
- **Base URL**:
  ```text
  POST https://generativelanguage.googleapis.com/v1beta/models/<model>:generateContent?key=<apiKey>
  ```

---

## 3. Payload Construction & Image Encoding
Images are selected via `ImagePicker` (camera or gallery), compressed, and encoded to standard Base64:

```json
{
  "contents": [
    {
      "parts": [
        {
          "inline_data": {
            "mime_type": "image/png",
            "data": "<base64_string>"
          }
        },
        {
          "text": "<instruction_prompt>"
        }
      ]
    }
  ]
}
```

---

## 4. Dedicated API Call Classes (`lib/backend/api_requests/api_calls.dart`)

1. **`ScanapibyauthenticatedUserCall`**:
   - Primary scanner for authenticated community members.
   - Saves classified image record to Supabase `image` table upon valid completion.
2. **`GuestScanCall`**:
   - Scans images for unauthenticated visitors without persisting image records to the database.
3. **`AuthScanCall`**:
   - Secondary authenticated scan route utilizing `gemini-2.5-flash`.
4. **`RevalidationScanCall`**:
   - Secondary verification pass to re-check ambiguous or disputed waste images.
5. **`DevCall`**:
   - Development and testing sandbox endpoint for tuning prompt heuristics.

---

## 5. Security & Key Scoping
API keys are injected via `String.fromEnvironment`:
- `GEMINI_API_KEY_SCAN_AUTHENTICATED_USER`
- `GEMINI_API_KEY_GUEST_SCAN`
- `GEMINI_API_KEY_REVALIDATION_SCAN`
- Fallback: `GEMINI_API_KEY`
This key separation prevents guest traffic from consuming production scan quota.
