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
  - Displays raw AI attributes: `valid_waste_image`, `recyclable`, `segregated`, `biodegradable`.
  - Moderation controls: Approve/Verify status or Flag as invalid.

### 2.4 Informational Dialog (`CImageInformationalDialogWidget`)
- **Location**: `lib/image/c_image_informational_dialog/`
- Displays explanation of classification badges (e.g. why an item is deemed non-segregated or non-biodegradable) to educate users.
