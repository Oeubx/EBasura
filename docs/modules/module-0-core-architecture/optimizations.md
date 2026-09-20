# Module 0 Optimizations & Technical Rationales

## Canonical Reference
- **Module**: Core Architecture, Setup & State Management
- **Catalog Authority**: [`../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-0-core-architecture-setup--state-management-ebasura-m0-f`](../../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-0-core-architecture-setup--state-management-ebasura-m0-f)
- **Primary Feature Codes**: `[EBASURA-M0-F0]`, `[EBASURA-M0-F1]`, `[EBASURA-M0-F2]`, `[EBASURA-M0-F3]`

---

## 1. Before vs. After Summary

| Feature Code | Area / Target | Before (Current Implementation) | After (Optimized Architecture) |
| :--- | :--- | :--- | :--- |
| `EBASURA-M0-F1` | Point Deduction Logic (`custom_functions.dart:25-30`) | `minusPoints(initialValue, amountOfPoints)` adds points (`initialValue + amountOfPoints`). | Inverted to arithmetic subtraction (`initialValue - amountOfPoints`), preserving point ledger integrity. |
| `EBASURA-M0-F1` | Timezone Conversion (`custom_functions.dart:36-38`) | Hardcoded `subtract(const Duration(hours: 8))` assumes an arbitrary static offset. | Standardized with `DateTime.toUtc()` and `DateTime.toLocal()`, respecting client device locale. |
| `EBASURA-M0-F2` | Supabase Exception Handling | Raw Postgrest exceptions bubble up uncaught, occasionally crashing the widget tree. | Safe query wrappers with type-safe error boundaries returning `Result<T>` or empty collections. |
| `EBASURA-M0-F3` | Reactive Auth State Provider | Rapid auth transitions risk redundant rebuilds when navigating across unauthenticated landing pages. | Guarded notify updates using `notifyOnAuthChange` flag toggles during sequential push routes. |

---

## 2. In-Depth Architectural & Technical Rationales

### 2.1 Arithmetic Inversion in `minusPoints` (`EBASURA-M0-F1`)
- **Root Cause**:
  In `lib/flutter_flow/custom_functions.dart`, `minusPoints` was implemented as:
  ```dart
  int minusPoints(int initialValue, int amountOfPoints) {
    return initialValue + amountOfPoints;
  }
  ```
- **Consequence**:
  Whenever an administrator flagged fraudulent waste submissions or initiated a moderation rollback, the offending user's account was awarded additional points rather than being penalized. This corrupted the `user_subtable.total_points` balance and distorted the community leaderboard.
- **Optimization Strategy**:
  Correct the operator to `initialValue - amountOfPoints` and enforce non-negative floor boundaries (`math.max(0, initialValue - amountOfPoints)`).

### 2.2 Timezone Normalization in `getCurrentTime` (`EBASURA-M0-F1`)
- **Root Cause**:
  Hardcoding a manual 8-hour offset (`currentTimeValue.subtract(const Duration(hours: 8))`) assumes all client devices operate in Philippine Standard Time (UTC+8) and conflicts with Postgres `timestamptz` columns that natively store UTC timestamps.
- **Optimization Strategy**:
  Rely on Dart's native `DateTime.now().toUtc()` when communicating with Supabase, and format output timestamps using `DateFormat` with device-local time for visual display.
