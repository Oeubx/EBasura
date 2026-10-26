# Image Filtering, Categorization & Moderation Actions

## 1. Scope & Responsibility
Documents the segmented query feeds, moderation controls, and deletion mechanisms applied to uploaded waste images.

---

## 2. Tri-State Lifecycle & Categorized Feeds Hub (`lib/image/image_filtered/`)
Physical waste attributes (`isSegregated`, `category_recycling`, `category_biode`, `category_nonbiode`) are decoupled from moderation lifecycle status.
The database enforces a strict Tri-State check constraint `chk_image_tri_state_status`: `status IN ('Non-Verified', 'Verified', 'Flagged')`.

1. **`PImagesViewAllAiWidget`** (`/pImagesViewAllAi`):
   - Feeds containing items with fresh AI automated evaluations pending community verifier consensus (`status = 'Non-Verified'`, `verification_status = 'pending'`).
2. **`PImagesViewAllSegregatedWidget`** (`/pImagesViewAllSegregated`):
   - Feeds containing images classified with `isSegregated == true`. Used to highlight best community segregation practices.
3. **`PImagesViewAllUnsegregatedWidget`** (`/pImagesViewAllUnsegregated`):
   - Mixed waste items (`isSegregated == false`). Used to identify problem areas needing community education or intervention.
4. **`PImagesViewAllVerifiedWidget`** (`/pImagesViewAllVerified`):
   - Images verified by administrators or verifiers with awarded points finalized (`status = 'Verified'`, `verification_status IN ('verified', 'corrected')`).
5. **`PImagesViewAllUncategorizedWidget`** (`/pImagesViewAllUncategorized`):
   - Fallback queue for images whose AI attributes were ambiguous or incomplete (`ai_classification = 'Unclassified'`).
6. **`PImagesViewAllFlaggedWidget`** (`/pImagesViewAllFlagged`):
   - Quarantined images flagged by the prompt injection guard, suspected spam, or non-waste submissions (`status = 'Flagged'`, `verification_status IN ('rejected', 'disputed')`).
---

## 3. Moderation & Deletion Flow (`CImageDeletionWidget`)
- **Location**: `lib/image/c_image_deletion/`
- **Permissions**: Image owner (uploader) or platform administrator.
- **Workflow**:
  1. Displays confirmation modal with warning about irreversible deletion.
  2. On confirm, deletes binary asset from Supabase Storage (`Image_Bucket`).
  3. Deletes record from Postgres `Image` table.
  4. If points had already been granted and deleted by admin due to fraud, triggers point rollback in `user_subtable`.
