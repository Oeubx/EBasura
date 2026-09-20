# Module 0: Core Architecture, Setup & State Management

## 1. Overview
Module 0 forms the foundational substrate of the **EBasura** application. Built upon Flutter (compatible with Flutter 3.x), the system integrates FlutterFlow's generated engine, application-wide reactive state notification, Supabase backend initialization, and multi-environment credential configuration.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M0-F0` | Repository & Environment Governance | Active | `env.json`, `env.json.example`, `analysis_options.yaml` | [`supabase_client_and_environment.md`](supabase_client_and_environment.md) |
| `EBASURA-M0-F1` | FlutterFlow Core Engine & Theme Provider | Active | `lib/flutter_flow/flutter_flow_theme.dart`, `lib/flutter_flow/flutter_flow_util.dart` | [`flutterflow_engine.md`](flutterflow_engine.md) |
| `EBASURA-M0-F2` | Supabase Client & Backend Infrastructure | Active | `lib/backend/supabase/supabase.dart`, `lib/main.dart` | [`supabase_client_and_environment.md`](supabase_client_and_environment.md) |
| `EBASURA-M0-F3` | Reactive App State Management | Active | `lib/flutter_flow/nav/nav.dart` (`AppStateNotifier`) | [`flutterflow_engine.md`](flutterflow_engine.md) |

---

## 3. Submodule Directory

- **[`flutterflow_engine.md`](flutterflow_engine.md)**: Deep dive into the UI engine, reactive state listeners (`AppStateNotifier`), internationalization/formatting utilities, and theme tokens.
- **[`supabase_client_and_environment.md`](supabase_client_and_environment.md)**: Specifications for Supabase SDK initialization, Postgres table binding classes, storage bucket connectors, and environment secret protection.
