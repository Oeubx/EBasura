# Module 10 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Navigation & Shared Components
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-10-navigation--shared-components-ebasura-m10-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-10-navigation--shared-components-ebasura-m10-f)
- **Primary Feature Codes**: `[EBASURA-M10-F0]`, `[EBASURA-M10-F1]`, `[EBASURA-M10-F2]`, `[EBASURA-M10-F3]`, `[EBASURA-M10-F4]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M10-F1` | Feed Refresh Interactions | No pull-to-refresh on feed and home screens; users must restart or leave and re-enter pages. | Universal `RefreshIndicator` gesture wrapping all primary scroll views for intuitive manual reload. |
| `EBASURA-M10-F1` | Layout Responsiveness | Rigid pixel container heights (e.g. `height: 525.0`) cause yellow-and-black pixel overflows on smaller phones. | Dynamic `Expanded` / `Flexible` and `SafeArea` wrappers adapting smoothly to all screen ratios. |
| `EBASURA-M10-F3` | Bottom Navigation Highlights | Tab highlight evaluation relies on literal string equality without handling sub-routes. | Route-aware path prefix matching (`GoRouterState.of(context).matchedLocation`) for accurate active tab highlighting. |
| `EBASURA-M10-F4` | Async Loading Placeholders | Generic circular progress spinners cause jarring layout shifts when images finish loading. | Shimmer skeleton cards providing smooth visual continuity during asynchronous data loading. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Fixed Heights vs Responsive Mobile Layouts (`EBASURA-M10-F1`)
- **Root Cause**:
  FlutterFlow generated multiple views (`PImagesViewAllWidget`, `PImagesViewAllUserWidget`, `PageFilteredImagesWidget`) using explicit fixed container dimensions (`Container(height: 525.0, child: Container(height: 425.0...))`). On budget Android devices with lower vertical resolutions (e.g. 720p or 480x800), this triggered RenderFlex overflow exceptions (`A RenderFlex overflowed by 48 pixels`). On large tablets, it created an awkward floating square with extensive wasted empty space.
- **Optimization Strategy**:
  Remove hardcoded vertical bounds. Enclose the scroll content inside flexible column structures using `Expanded` and `CustomScrollView` / `Sliver` architectures to guarantee seamless responsiveness across any screen size.

### 2.2 Image Loading Perceived Performance (`EBASURA-M10-F4`)
- **Root Cause**:
  Displaying a plain spinner while images load from Supabase Storage created perceptible visual pop-in once the byte stream resolved.
- **Optimization Strategy**:
  Implement lightweight shimmer skeleton tiles mimicking the card structure. Use `cached_network_image`'s `placeholder` attribute to display smooth shimmer animations while images load into memory.
