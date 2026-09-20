# Module 2 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: User Profile & Account Management
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-2-user-profile--account-management-ebasura-m2-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-2-user-profile--account-management-ebasura-m2-f)
- **Primary Feature Codes**: `[EBASURA-M2-F0]`, `[EBASURA-M2-F1]`, `[EBASURA-M2-F2]`, `[EBASURA-M2-F3]`, `[EBASURA-M2-F4]`, `[EBASURA-M2-F5]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M2-F0` | Profile Gamification Summary | Static text displays current total points without context on distance to next achievement. | Interactive milestone progression bar visualizing points needed for next badge unlock tier. |
| `EBASURA-M2-F1` | Avatar Upload & Cropping | Uncompressed full-resolution gallery photos are uploaded directly to Supabase storage. | Client-side compression and square aspect ratio crop (max 512x512, JPEG 85%), reducing storage consumption. |
| `EBASURA-M2-F4` | Account Settings Caching | Settings switch toggles invoke immediate non-debounced network requests on every tap. | Debounced settings updates with optimistic UI toggling and offline cache persistence in `SharedPreferences`. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Client-Side Avatar Optimization (`EBASURA-M2-F1`)
- **Root Cause**:
  Users uploading camera photos as avatars transmit 4-12MB files directly to Supabase Storage `user_avatars/` bucket. These heavy image assets slow down profile loading and consume high client bandwidth across all leaderboard and feed widgets.
- **Optimization Strategy**:
  Enforce client-side resizing and compression before storage transmission, standardizing dimensions to 512x512 pixels and limiting payload sizes under 150KB.

### 2.2 Gamification Progress Feedback Loops (`EBASURA-M2-F0`)
- **Root Cause**:
  The profile view displayed points in isolation without showing users how close they were to earning the next achievement badge.
- **Optimization Strategy**:
  Evaluate the user's current points against the lowest locked badge threshold in `BadgeTable` and render an animated percentage progress indicator to encourage waste disposal participation.
