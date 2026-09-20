---
name: git-commits
description: Drafts or executes backlog-linked conventional git commit messages for the EBasura repository referencing the canonical sprint backlog catalog.
---

# EBasura Git Commit Skill

Use this skill whenever asked to draft, generate, review, or execute a git commit for the `EBasura` repository.

## Required References

1. Read `AGENTS.md` at the root of the repository.
2. Search and consult `docs/backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md` to map changes to the appropriate `[EBASURA-M#-F#]` feature code.
3. Review corresponding module documentation under `docs/modules/` for context if needed.

---

## Commit Grammar Contract

All commits in EBasura must strictly follow Conventional Commits and append the canonical backlog code:

```text
<type>(<scope>): <concise description in past-tense> [EBASURA-M#-F#]

- <Past-tense change bullet>
- <Past-tense change bullet>
```

### Examples:
- `feat(gemini): integrated visual prompt injection guard for waste scans [EBASURA-M3-F4]`
- `fix(auth): handled invalid session refresh during app launch [EBASURA-M1-F6]`
- `docs(modules): compiled module 7 garbage collection schedules specifications [EBASURA-M7-F0]`
- `chore(deps): upgraded supabase_flutter package dependencies [EBASURA-M0-F0]`

---

## Workflow

### 1. Inspect Changes
Check modified and untracked files:
```powershell
git status --short
git diff --stat
```

### 2. Map to Module & Feature Code
Consult `docs/backlogs/EBASURA_Sprint_Backlogs_Commit_Reference.md` and locate the best match:
- **Module 0**: Core Architecture, Setup & State Management (`EBASURA-M0-F0` to `F3`)
- **Module 1**: Authentication, Identity & Security (`EBASURA-M1-F0` to `F6`)
- **Module 2**: User Profile & Account Management (`EBASURA-M2-F0` to `F5`)
- **Module 3**: AI Waste Scanning & Classification (`EBASURA-M3-F0` to `F5`)
- **Module 4**: Waste Image Records, Inspection & Moderation (`EBASURA-M4-F0` to `F6`)
- **Module 5**: Gamification, Points System & Badges (`EBASURA-M5-F0` to `F4`)
- **Module 6**: Waste Reporting & Incident Alerts (`EBASURA-M6-F0` to `F4`)
- **Module 7**: Garbage Collection Schedules (`EBASURA-M7-F0` to `F4`)
- **Module 8**: Street & Community Directory (`EBASURA-M8-F0` to `F4`)
- **Module 9**: Administrator Operations & User Management (`EBASURA-M9-F0` to `F5`)
- **Module 10**: Shared Navigation & Core Components (`EBASURA-M10-F0` to `F4`)

*For general workspace chores or full-system tests not tied to a specific feature, use `F0` under the corresponding module (e.g., `[EBASURA-M0-F0]`).*

### 3. Determine Commit Type & Scope
- **Valid Types**: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, `ci`, `revert`.
- **Valid Scopes**: `core`, `auth`, `profile`, `gemini`, `waste-scan`, `records`, `moderation`, `gamification`, `points`, `badges`, `reports`, `schedules`, `streets`, `admin`, `nav`, `ui`, `deps`, `root`.

### 4. Safety & Secret Checks
Before presenting or executing:
- Verify `env.json` with real API keys is **NOT** staged.
- Ensure untracked temporary files or build artifacts (`build/`, `.dart_tool/`) are not included.
- Verify file paths referenced in bullets are relative to the repo root.
- Ensure messages are encoded as **UTF-8 without BOM**.

### 5. Execution (Only upon Explicit Approval)
You **MUST NOT** execute `git commit` or `git push` automatically. Always present the draft message and command to the user and wait for their explicit instruction.
When instructed:
```powershell
git commit -m "<type>(<scope>): <concise description> [EBASURA-M#-F#]" -m "- <bullet 1>" -m "- <bullet 2>"
```
*(Always pass messages directly via command arguments to avoid PowerShell BOM or escape issues).*
