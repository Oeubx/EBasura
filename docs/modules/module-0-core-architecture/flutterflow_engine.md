# FlutterFlow Engine & State Architecture

## 1. Scope & Responsibility
This submodule documents the core presentation engine, application lifecycle observation, and global state synchronization mechanisms powering EBasura.

---

## 2. Global State & Navigation Notification (`AppStateNotifier`)
The state broker is encapsulated in `lib/flutter_flow/nav/nav.dart` via the singleton `AppStateNotifier`:

```dart
class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;
  ...
}
```

### Key Behaviors:
- **Authentication Reactive Wakeup**: Notifies `GoRouter` when `user` changes or logs in/out.
- **Splash Shield**: Prevents UI flickers by maintaining `showSplashImage = true` until authentication bootstrap is fully settled.
- **Deep-linking & Auth Intercept**: Preserves `_redirectLocation` so that unauthorized guests attempting to access protected screens are redirected back post-login.

---

## 3. Theming & Design System Tokens (`FlutterFlowTheme`)
Located at `lib/flutter_flow/flutter_flow_theme.dart`:
- Master Design System & Swatches: see [`../../design_system/brand_and_design_system.md`](../../design_system/brand_and_design_system.md) and [`../../design_system/README.md`](../../design_system/README.md).
- Provides tokenized theme engine with the 6 canonical color tokens:
  - `accent3` / `brandBlue`: `#2E78A6` (Deep Slate Ocean Blue).
  - `accent4` / `skyTint`: `#A3C9D9` (Soft Sky Blue Tint).
  - `secondaryBackground` / `mintTint`: `#D5F2E2` (Pale Mint Sage).
  - `ecoPrimary`: `#31A11F` (Vibrant Eco Green for recyclable badges and verified actions).
  - `ecoSecondary`: `#70BF5A` (Fresh Leaf Green for streaks and gamification points).
  - `primaryBackground` / `surfaceCanvas`: `#F2F2F2` (Clean Canvas Neutral).
  - `primaryText`: `#013448` (Deep Slate Charcoal for WCAG AAA compliance).
  - `success`: `#31A11F` (Aligned with canonical Eco Green).
- Design Tokens (`FFDesignTokens`):
  - `FFRadius`: `sm: 8.0`, `md: 16.0`, `pill: 22.0` (standard pill geometry for Buttons 1â€“4), `lg: 24.0`, `full: 9999.0`.
  - `FFSpacing`: `xs: 4.0`, `sm: 8.0`, `md: 16.0`, `lg: 24.0`, `xl: 32.0`.
  - `FFShadows`: Standardized 10% black shadows (`Color(0x1A000000)`).
- Typography presets: `displayLarge`, `displayMedium`, `headlineLarge`, `titleMedium`, `labelMedium`, and `bodyMedium`.

---

## 4. Utility Suite (`FlutterFlowUtil`)
Located at `lib/flutter_flow/flutter_flow_util.dart`:
- Date/time formatters, relative timestamps ("x hours ago"), and localized number formatting.
- Safe type casting functions: `castToType<T>(dynamic val)`.
- JSON field extractors with JSONPath query compatibility.
- Responsive breakpoints and layout constraints detection (`responsiveVisibility`).
