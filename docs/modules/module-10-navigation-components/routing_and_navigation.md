# Application Routing, Navigation & Page Transitions

## 1. Scope & Responsibility
Documents the route configuration table, auth redirection, deep-link parameter parsing, and transition animations managed by `GoRouter`.

---

## 2. Router Configuration (`lib/flutter_flow/nav/nav.dart`)
Configured via `createRouter(AppStateNotifier appStateNotifier)`:

- **Initial Location**: `'/'`
- **Error & Root Redirection**:
  - Unauthenticated -> `LandingPageWidget`
  - Authenticated -> `PageHomepageWidget`
- **Route Definitions**: Over 30 specialized routes covering all user, verifier, and administrator views with typed parameter extraction (`SupabaseRow`, `String`, `int`).

### Helper Extensions:
- `context.goNamedAuth(String name, bool mounted, ...)`: Gated navigation that intercepts unauthenticated attempts and preserves redirect intentions.
- `context.pushNamedAuth(...)`: Stack-based push navigation respecting auth state.

---

## 3. Core Navigation Pages

### 3.1 Homepage (`PageHomepageWidget`)
- **Location**: `lib/page_homepage/`
- **Route**: `/pageHomepage`
- **Capabilities**:
  - Core landing dashboard for users and visitors.
  - Quick action buttons: "Scan Waste", "View Schedules", "Submit Report", "Leaderboard".
  - Recent community activity snippet.

### 3.2 Sub-Features Directory (`PageViewSubFeaturesWidget`)
- **Location**: `lib/page_view_sub_features/`
- **Route**: `/pageViewSubFeatures`
- **Capabilities**: Complete categorized directory of secondary capabilities (filtered feeds, verifier tools, about documents) for easy discovery.
