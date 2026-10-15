# EBasura Agent Guidelines & Rules

## Project Context

**EBasura** (AEBasura) is a smart, gamified waste management and reporting mobile application built with:
- **Frontend / Client**: Flutter (Dart) with FlutterFlow UI components
- **Backend & Database**: Supabase (Auth, Postgres Tables, Storage)
- **AI Classification**: Google Gemini REST API (e.g., `gemini-2.5-flash`, `gemini-flash-latest`) for waste scanning, recyclability detection, and prompt injection guards

---

## Canonical Documentation & Backlogs

- **Brand Identity & Design System**: [`docs/EBASURA_BRAND_AND_DESIGN_SYSTEM.md`](docs/EBASURA_BRAND_AND_DESIGN_SYSTEM.md) *(Mandatory reference for all UI/frontend work)*
- **Sprint Backlogs & Commit Reference**: [`docs/backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md`](docs/backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md)
- **Modular Technical Specifications**:
  - **Module 0**: [`docs/modules/module-0-core-architecture/README.md`](docs/modules/module-0-core-architecture/README.md)
  - **Module 1**: [`docs/modules/module-1-auth-identity/README.md`](docs/modules/module-1-auth-identity/README.md)
  - **Module 2**: [`docs/modules/module-2-profile-account/README.md`](docs/modules/module-2-profile-account/README.md)
  - **Module 3**: [`docs/modules/module-3-ai-waste-scanning/README.md`](docs/modules/module-3-ai-waste-scanning/README.md)
  - **Module 4**: [`docs/modules/module-4-image-records-moderation/README.md`](docs/modules/module-4-image-records-moderation/README.md)
  - **Module 5**: [`docs/modules/module-5-gamification-leaderboard/README.md`](docs/modules/module-5-gamification-leaderboard/README.md)
  - **Module 6**: [`docs/modules/module-6-waste-reporting/README.md`](docs/modules/module-6-waste-reporting/README.md)
  - **Module 7**: [`docs/modules/module-7-collection-schedules/README.md`](docs/modules/module-7-collection-schedules/README.md)
  - **Module 8**: [`docs/modules/module-8-street-directory/README.md`](docs/modules/module-8-street-directory/README.md)
  - **Module 9**: [`docs/modules/module-9-admin-operations/README.md`](docs/modules/module-9-admin-operations/README.md)
  - **Module 10**: [`docs/modules/module-10-navigation-components/README.md`](docs/modules/module-10-navigation-components/README.md)

---

## Safety & Security Critical Rules

1. **Never Commit Secrets or Sensitive Files**:
   - `env.json` contains active environment configurations and sensitive credentials (Gemini API keys, Supabase URLs, anon keys).
   - Ensure `env.json` is always protected and never committed with production secrets. Use `env.json.example` for tracked template keys.
   - Never stage credentials, API tokens, or service role keys.
2. **Commit & Push Execution Gating**:
   - You **MUST NOT** execute `git commit` or `git push` automatically without explicit user request or approval in chat.
   - Always present draft commit messages and commands to the user first.
3. **Backlog-Linked Conventional Commits**:
   - Every commit must include the relevant backlog code: `<type>(<scope>): <concise description in past-tense> [EBASURA-M#-F#]`.
   - Consult `docs/backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md` to identify the correct feature code.
4. **Encoding Integrity**:
   - Always write files as **UTF-8 without BOM** on Windows to avoid byte-order mark corruption.
5. **Dart & Flutter Code Standards**:
   - Maintain clean code passing `flutter analyze` with 0 errors.
   - Keep relative imports consistent within `lib/`.
6. **UI & Frontend Design Mandate**:
   - For **EVERY UI/frontend change, layout adjustment, component creation, or styling update**, agents **MUST ALWAYS** refer to [`docs/EBASURA_BRAND_AND_DESIGN_SYSTEM.md`](docs/EBASURA_BRAND_AND_DESIGN_SYSTEM.md).
   - Enforce the 6 canonical color tokens: `#2E78A6` (Ocean Blue), `#A3C9D9` (Sky Blue), `#D5F2E2` (Mint Tint), `#31A11F` (Eco Green), `#70BF5A` (Leaf Green), `#F2F2F2` (Neutral Canvas).
   - Enforce the dual-font hierarchy: **Comfortaa** exclusively for Brand Logo, wordmark, and splash/achievement identity; **Inter** / **Inter Tight** for all User Interface controls, buttons, forms, labels, and body text.
   - Enforce pill button geometries (16.0–22.0px radius) and high-contrast button styles (Buttons 1–4 specs).
7. **Mandatory Git Commits Skill Execution (`git-commits`)**:
   - **EVERY TIME there are code or configuration changes in this conversation (or any session)**, agents **MUST ALWAYS** use the skill [`.agents/skills/git-commits/SKILL.md`](.agents/skills/git-commits/SKILL.md) to inspect changes, map them to canonical backlog tags (`[EBASURA-M#-F#]`), and formulate conventional commit drafts.

---

## Skills Cheat Sheet

The following repository skills are available in `.agents/skills/`:

| Skill | Trigger Phrases | Purpose |
| :--- | :--- | :--- |
| `git-commits` | **MANDATORY for every code change in conversation**, "commit", "draft commit", "save changes" | Inspects changes and drafts/executes conventional git commits with `[EBASURA-M#-F#]` tags. |
| `github-pr` | "create PR", "open pull request", "push feature", "prepare PR" | Prepares branches and GitHub pull requests with structured descriptions. |
| `staging-readiness-audit` | "audit readiness", "pre-flight check", "ready to push", "check staging" | Scans for secret leaks (`env.json`), git drift, brand token compliance, and runs `flutter analyze`. |
| `pr-check-fix` | "fix PR checks", "fix CI errors", "resolve test failures" | Diagnoses and resolves failing CI/PR checks (analyzer, format, tests). |
| `project-verification` | "verify", "run tests", "check project", "verify build" | Executes standard Flutter quality checks (`flutter analyze`, `flutter test`). |
| `workspace-onboarding` | "start working on", "work on EBasura", "onboard" | Emits pre-flight environment check (Flutter SDK, env setup, brand docs). |
| `apk-release` | "build apk", "release apk", "create apk", "package release" | Packages release APK with env secrets, versions, hashes, and updates release docs. |

