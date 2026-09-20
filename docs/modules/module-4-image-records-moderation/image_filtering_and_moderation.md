# Image Filtering, Categorization & Moderation Actions

## 1. Scope & Responsibility
Documents the segmented query feeds, moderation controls, and deletion mechanisms applied to uploaded waste images.

---

## 2. Categorized Feeds Hub (`lib/image/image_filtered/`)
The system routes images into dedicated category views for specialized review:

1. **`PImagesViewAllAiWidget`** (`/pImagesViewAllAi`):
   - Feeds containing items with fresh AI automated evaluations pending community verifier consensus.
2. **`PImagesViewAllSegregatedWidget`** (`/pImagesViewAllSegregated`):
   - Feeds containing images classified with `segregated == true`. Used to highlight best community segregation practices.
3. **`PImagesViewAllUnsegregatedWidget`** (`/pImagesViewAllUnsegregated`):
   - Mixed waste items (`segregated == false`). Used to identify problem areas needing community education or intervention.
4. **`PImagesViewAllVerifiedWidget`** (`/pImagesViewAllVerified`):
   - Images verified by administrators or verifiers with awarded points finalized.
5. **`PImagesViewAllUncategorizedWidget`** (`/pImagesViewAllUncategorized`):
   - Fallback queue for images whose AI attributes were ambiguous or incomplete.
6. **`PImagesViewAllFlaggedWidget`** (`/pImagesViewAllFlagged`):
   - Quarantined images flagged by the prompt injection guard, suspected spam, or non-waste submissions.

---

## 3. Moderation & Deletion Flow (`CImageDeletionWidget`)
- **Location**: `lib/image/c_image_deletion/`
- **Permissions**: Image owner (uploader) or platform administrator.
- **Workflow**:
  1. Displays confirmation modal with warning about irreversible deletion.
  2. On confirm, deletes binary asset from Supabase Storage (`waste_images/`).
  3. Deletes record from Postgres `image` table.
  4. If points had already been granted and deleted by admin due to fraud, triggers point rollback in `user_subtable`.
