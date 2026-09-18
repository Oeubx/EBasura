# EBasura Agent Guidelines & Rules

## Project Context

**EBasura** (AEBasura) is a smart, gamified waste management and reporting mobile application built with:
- **Frontend / Client**: Flutter (Dart) with FlutterFlow UI components
- **Backend & Database**: Supabase (Auth, Postgres Tables, Storage)
- **AI Classification**: Google Gemini REST API (e.g., `gemini-2.5-flash`, `gemini-flash-latest`) for waste scanning, recyclability detection, and prompt injection guards

---

## Safety & Security Critical Rules

1. **Never Commit Secrets or Sensitive Files**:
   - `env.json` contains active environment configurations and sensitive credentials (Gemini API keys, Supabase URLs, anon keys).
   - Ensure `env.json` is always protected and never committed with production secrets. Use `env.json.example` for tracked template keys.
   - Never stage credentials, API tokens, or service role keys.
2. **Commit & Push Execution Gating**:
   - You **MUST NOT** execute `git commit` or `git push` automatically without explicit user request or approval in chat.
   - Always present draft commit messages and commands to the user first.
3. **Encoding Integrity**:
   - Always write files as **UTF-8 without BOM** on Windows to avoid byte-order mark corruption.
4. **Dart & Flutter Code Standards**:
   - Maintain clean code passing `flutter analyze` with 0 errors.
   - Keep relative imports consistent within `lib/`.

---

## Skills Cheat Sheet

The following repository skills are available in `.agents/skills/`:

| Skill | Trigger Phrases | Purpose |
| :--- | :--- | :--- |
| `git-commits` | "commit", "draft commit", "save changes", "commit message" | Drafts or executes conventional git commits with clear scopes and change bullets. Backlog-free. |
| `github-pr` | "create PR", "open pull request", "push feature", "prepare PR" | Prepares branches and GitHub pull requests with structured descriptions. |
| `staging-readiness-audit` | "audit readiness", "pre-flight check", "ready to push", "check staging" | Scans for secret leaks (`env.json`), git drift, and runs `flutter analyze`. |
| `pr-check-fix` | "fix PR checks", "fix CI errors", "resolve test failures" | Diagnoses and resolves failing CI/PR checks (analyzer, format, tests). |
| `project-verification` | "verify", "run tests", "check project", "verify build" | Executes standard Flutter quality checks (`flutter analyze`, `flutter test`). |
| `workspace-onboarding` | "start working on", "work on EBasura", "onboard" | Emits pre-flight environment check (Flutter SDK, env setup). |
