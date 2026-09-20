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
- Provides dark/light theme switching with strict tokenized color palettes:
  - `primary`: Core application branding color (Eco Green).
  - `secondary`: Secondary accent (Dark Green / Forest).
  - `tertiary`: Gamification and highlight accents.
  - `alternate`: Subdued borders, separators, and background tints.
  - `error`: Warning states and validation failure indicators.
- Typography presets: `displayLarge`, `displayMedium`, `headlineLarge`, `titleMedium`, `labelMedium`, and `bodyMedium`.

---

## 4. Utility Suite (`FlutterFlowUtil`)
Located at `lib/flutter_flow/flutter_flow_util.dart`:
- Date/time formatters, relative timestamps ("x hours ago"), and localized number formatting.
- Safe type casting functions: `castToType<T>(dynamic val)`.
- JSON field extractors with JSONPath query compatibility.
- Responsive breakpoints and layout constraints detection (`responsiveVisibility`).
