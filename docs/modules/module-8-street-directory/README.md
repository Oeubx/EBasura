# Module 8: Street & Community Directory

## 1. Overview
Module 8 manages the geographic street and community sector directory of EBasura. Streets serve as the foundational foreign-key link for waste collection schedules, waste incident reports, and community waste image uploads.

---

## 2. Feature Matrix

| Feature Code | Feature Name | Status | Primary Artifacts | Technical Documentation |
| :--- | :--- | :--- | :--- | :--- |
| `EBASURA-M8-F0` | Community Street Index Directory | Active | `lib/admin/street/p_street_view_all/` | [`street_registry.md`](street_registry.md) |
| `EBASURA-M8-F1` | Street Profile & Schedule Summary | Active | `lib/admin/street/p_street_view_one/` | [`street_registry.md`](street_registry.md) |
| `EBASURA-M8-F2` | Admin Street Registration Flow | Active | `lib/admin/street/c_street_creation/` | [`street_management.md`](street_management.md) |
| `EBASURA-M8-F3` | Street Deletion & Cascade Safety | Active | `lib/admin/street/c_street_deletion/` | [`street_management.md`](street_management.md) |
| `EBASURA-M8-F4` | Street Table Schema & Relations | Active | `lib/backend/supabase/database/tables/street.dart` | [`street_management.md`](street_management.md) |

---

## 3. Submodule Directory

- **[`street_registry.md`](street_registry.md)**: Specifications for public street browsing, searching, street detail summaries, and linked schedules.
- **[`street_management.md`](street_management.md)**: Specifications for administrator street creation, deletion safeguards, and Postgres relational schemas.
