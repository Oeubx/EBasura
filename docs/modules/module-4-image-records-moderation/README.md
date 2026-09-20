# Module 4: Waste Image Records, Inspection & Moderation

## 1. Overview
Module 4 manages the persistence, browsing, filtering, and moderation of scanned waste records. It provides personal history feeds for authenticated users, a public verification feed, categorized filtering lists (segregated, flagged, etc.), and inspection/deletion tools for administrators and community verifiers.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M4-F0` | User Personal Upload History | Active | `lib/image/image_views/p_images_view_all_user/` | [`image_views_and_history.md`](image_views_and_history.md) |
| `EBASURA-M4-F1` | Public Waste Feed & Gallery | Active | `lib/image/image_views/p_images_view_all/` | [`image_views_and_history.md`](image_views_and_history.md) |
| `EBASURA-M4-F2` | Verifier Inspection & Audit View | Active | `lib/image/image_views/p_img_view_verifier/` | [`image_views_and_history.md`](image_views_and_history.md) |
| `EBASURA-M4-F3` | Category Filter Hub & Feeds | Active | `lib/image/image_filtered/` | [`image_filtering_and_moderation.md`](image_filtering_and_moderation.md) |
| `EBASURA-M4-F4` | Flagged & Suspicious Waste Moderation | Active | `p_images_view_all_flagged/` | [`image_filtering_and_moderation.md`](image_filtering_and_moderation.md) |
| `EBASURA-M4-F5` | Image Record Deletion & Cleanup | Active | `lib/image/c_image_deletion/` | [`image_filtering_and_moderation.md`](image_filtering_and_moderation.md) |
| `EBASURA-M4-F6` | Image Informational Dialogs | Active | `lib/image/c_image_informational_dialog/` | [`image_views_and_history.md`](image_views_and_history.md) |

---

## 3. Submodule Directory

- **[`image_views_and_history.md`](image_views_and_history.md)**: Specifications for personal scan galleries, public image feeds, verifier audit screens, and modal dialogs.
- **[`image_filtering_and_moderation.md`](image_filtering_and_moderation.md)**: Specifications for categorized filter queries (AI classified, segregated, unsegregated, flagged, verified), admin review queues, and image deletion cascades.
