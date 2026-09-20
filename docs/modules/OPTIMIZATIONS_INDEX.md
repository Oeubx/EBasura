# EBasura System Optimizations & Architectural Modernization Guide

This directory contains the canonical per-module architectural optimization specifications for the **EBasura** mobile ecosystem. Each module document provides a concise **Before vs. After summary table** followed by an **in-depth technical rationale** explaining the root cause, chosen design patterns, and systemic impact.

All specifications cross-reference feature tracking codes defined in the canonical authority:
👉 [`../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md)

---

## Modular Optimization Directory

| Module | Scope | Canonical Backlog Link | Optimization Specification |
| :--- | :--- | :--- | :--- |
| **Module 0** | Core Architecture, State & Backend Infrastructure | [`EBASURA-M0-F0..F3`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-0-core-architecture-setup--state-management-ebasura-m0-f) | [`module-0-core-architecture/optimizations.md`](module-0-core-architecture/optimizations.md) |
| **Module 1** | Authentication, Identity & Session Security | [`EBASURA-M1-F0..F6`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-1-authentication-identity--security-ebasura-m1-f) | [`module-1-auth-identity/optimizations.md`](module-1-auth-identity/optimizations.md) |
| **Module 2** | User Profile & Account Settings | [`EBASURA-M2-F0..F5`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-2-user-profile--account-management-ebasura-m2-f) | [`module-2-profile-account/optimizations.md`](module-2-profile-account/optimizations.md) |
| **Module 3** | AI Waste Scanning & Gemini Classification | [`EBASURA-M3-F0..F5`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-3-ai-waste-scanning--classification-ebasura-m3-f) | [`module-3-ai-waste-scanning/optimizations.md`](module-3-ai-waste-scanning/optimizations.md) |
| **Module 4** | Waste Records, Multi-Filtering & Moderation | [`EBASURA-M4-F0..F6`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-4-waste-image-records-inspection--moderation-ebasura-m4-f) | [`module-4-image-records-moderation/optimizations.md`](module-4-image-records-moderation/optimizations.md) |
| **Module 5** | Gamification, Leaderboards & Badges | [`EBASURA-M5-F0..F4`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-5-gamification-points-system--badges-ebasura-m5-f) | [`module-5-gamification-leaderboard/optimizations.md`](module-5-gamification-leaderboard/optimizations.md) |
| **Module 6** | Waste Incident Reporting & Alerts | [`EBASURA-M6-F0..F4`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-6-waste-reporting--community-alerts-ebasura-m6-f) | [`module-6-waste-reporting/optimizations.md`](module-6-waste-reporting/optimizations.md) |
| **Module 7** | Garbage Collection Schedules & Routes | [`EBASURA-M7-F0..F4`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-7-garbage-collection-schedules-ebasura-m7-f) | [`module-7-collection-schedules/optimizations.md`](module-7-collection-schedules/optimizations.md) |
| **Module 8** | Community Street Directory & Geodata | [`EBASURA-M8-F0..F4`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-8-street--community-directory-ebasura-m8-f) | [`module-8-street-directory/optimizations.md`](module-8-street-directory/optimizations.md) |
| **Module 9** | Administrator Operations & Moderation Queue | [`EBASURA-M9-F0..F5`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-9-administrator-operations--user-management-ebasura-m9-f) | [`module-9-admin-operations/optimizations.md`](module-9-admin-operations/optimizations.md) |
| **Module 10** | Shared UI, Navigation & Responsive Shells | [`EBASURA-M10-F0..F4`](../backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md#module-10-navigation--shared-components-ebasura-m10-f) | [`module-10-navigation-components/optimizations.md`](module-10-navigation-components/optimizations.md) |

---

## Architectural Principles Applied Across All Modules

1. **Reactive Lifecycle Integrity**: Ensuring state updates and query filters properly re-evaluate streams and futures without relying on immutable caching operators (`??=`).
2. **Mobile Network & Memory Budget**: Enforcing client-side downscaling and compression before network payloads are dispatched, preventing high memory allocations and request timeouts.
3. **Deterministic Contract Enforcements**: Preferring strongly-typed JSON schemas over plain-text string splitting for AI model integrations.
4. **Data Consistency & Ledger Integrity**: Ensuring arithmetic point operations strictly balance across awards and rollbacks.
5. **DRY Code Consolidation**: Consolidating duplicated screen files into dynamic, parameterized components while preserving backward-compatible routing.
