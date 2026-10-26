# Image Views, Personal History & Verifier Inspection

## 1. Scope & Responsibility
Documents the presentation layers through which users inspect past uploads, explore public submissions, and community verifiers audit waste validity.

---

## 2. Component Specifications

### 2.1 User Personal Uploads (`PImagesViewAllUserWidget`)
- **Location**: `lib/image/image_views/p_images_view_all_user/`
- **Route**: `/pImagesViewAllUser`
- **Capabilities**:
  - Displays grid/list of images uploaded by the currently authenticated user (`uploader_id == currentUser.uid`).
  - Card components (`CImgViewUserWidget`) show upload timestamp, associated street, validity badge, and points awarded.
  - Tapping a card opens detailed image inspection or trigger deletion modal.

### 2.2 Public Community Waste Feed (`PImagesViewAllWidget`)
- **Location**: `lib/image/image_views/p_images_view_all/`
- **Route**: `/pImagesViewAll`
- **Capabilities**:
  - Publicly accessible feed of verified waste uploads from all community members.
  - Allows filtering by street or collection area.

### 2.3 Verifier Inspection View (`PImgViewVerifierWidget`)
- **Location**: `lib/image/image_views/p_img_view_verifier/`
- **Route**: `/pImgViewVerifier`
- **Parameters**: `imageIDref` (`ImageRow` Supabase reference).
- **Capabilities**:
  - High-resolution zoom inspection of the waste photograph.
  - Dual-Column Evaluation: Compares AI findings (`ai_classification`, `ai_waste_type`, `ai_confidence_score`) against Ground-Truth Admin overrides (`admin_classification`, `admin_waste_type`, `admin_id`).
  - Audit Latency Timer: Automatically records inspection duration (`verification_time_seconds`) starting when the screen opens (`initState`) until decision dispatch.
  - Moderation Outcomes:
    - **Verify (Agreement)**: Admin confirms AI findings $\to$ `status = 'Verified'`, `verification_status = 'verified'`. Awards gamification points.
    - **Verify (Correction)**: Admin corrects AI findings $\to$ `status = 'Verified'`, `verification_status = 'corrected'`. Awards points and logs correction for Chapter 5 Confusion Matrix evaluation.
    - **Flag**: Suspicious/fraudulent submission $\to$ `status = 'Flagged'`, `verification_status = 'rejected'`. Zero points.
### 2.4 Informational Dialog (`CImageInformationalDialogWidget`)
- **Location**: `lib/image/c_image_informational_dialog/`
- Displays explanation of classification badges (e.g. why an item is deemed non-segregated or non-biodegradable) to educate users.

### 2.5 Resident Dispute Decision Modal (`CDisputeDecisionWidget`)
- **Location**: `lib/image/c_dispute_decision/`
- **Component**: `CDisputeDecisionWidget`
- **Eligibility**: Broadened to any scan where `status != 'Verified' && !isDisputed` inside `CImgViewUserWidget`.
- **Workflow**:
  - Resident taps red gavel icon ("Dispute Verification Decision").
  - Selects dispute reason category from dropdown (e.g., *"AI Misclassification"*, *"Properly Segregated Waste"*).
  - Enters detailed rationale ($\ge 5$ characters).
  - On submit: updates `Image` row with `status = 'Flagged'`, `verification_status = 'disputed'`, and `remark = '[DISPUTE - <category>]: <reason>'`.
  - Re-renders `CImgViewUserWidget` with an amber *"Dispute Pending Verifier Review"* banner.
