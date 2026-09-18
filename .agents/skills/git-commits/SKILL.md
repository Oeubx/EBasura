---
name: git-commits
description: Drafts or executes clean, conventional git commit messages for the EBasura repository without requiring backlog or documentation tracking files.
---

# EBasura Git Commit Skill

Use this skill whenever asked to draft, generate, review, or execute a git commit for the `EBasura` repository.

## Guiding Principles

1. **Backlog-Free**: No sprint backlog references, tracking IDs, or markdown backlog document lookups are required. Commits are direct and focused on code changes.
2. **Conventional Commits**: Format must strictly follow the Conventional Commits specification with a scoped imperative subject and past-tense change bullets.
3. **Explicit User Gating**: You **MUST NOT** execute `git commit` or `git push` automatically. Always present the draft message and command to the user and wait for their explicit instruction.
4. **Encoding Integrity**: Write commit messages strictly using **UTF-8 without BOM** to avoid character corruption on Windows.

---

## Workflow

### 1. Inspect Changes
Check modified and untracked files:
```powershell
git status --short
git diff --stat
```

### 2. Determine Commit Type & Scope
Select the most appropriate type and scope:

- **Valid Types**:
  - `feat`: New feature or user-facing capability
  - `fix`: Bug fix
  - `refactor`: Code restructuring without functional changes
  - `chore`: Maintenance, config changes, build scripts, cleanup
  - `docs`: Documentation only changes
  - `style`: Formatting, missing semi-colons, whitespace
  - `test`: Adding or modifying tests
  - `perf`: Performance improvements
  - `ci`: CI/CD workflow updates

- **Valid Scopes for EBasura**:
  - `auth`: Supabase authentication, session handling, user profiles
  - `gemini`: Google Gemini AI integration, prompts, image classification, injection guards
  - `waste-scan`: Camera capture, image upload, scan result processing
  - `gamification`: Points system, leaderboards, badge awards
  - `schedule`: Waste collection schedules, timings, collector assignments
  - `streets`: Street directory, location filtering
  - `supabase`: Database queries, tables, storage bucket interactions
  - `ui`: Flutter widgets, themes, FlutterFlow layout components
  - `deps`: Dependency changes in `pubspec.yaml`
  - `root`: General project configuration or cross-cutting changes

### 3. Draft the Commit Message
Structure the message using this format:

```text
<type>(<scope>): <concise description in past-tense>

- <Past-tense change bullet>
- <Past-tense change bullet>
```

#### Example:
```text
feat(gemini): integrated prompt injection guard for waste scans

- Added heuristic and delimiter checks in Gemini scan service
- Handled classification fallback when injection pattern is detected
- Updated scan result model to flag suspicious input
```

### 4. Safety & Secret Checks
Before presenting or executing:
- Verify `env.json` with real API keys is **NOT** staged.
- Ensure untracked temporary files or build artifacts (`build/`, `.dart_tool/`) are not included.
- Verify file paths referenced are relative to repo root.

### 5. Execution (Only upon Explicit Approval)
When the user explicitly instructs to commit:
```powershell
git commit -m "<type>(<scope>): <concise description>" -m "- <bullet 1>" -m "- <bullet 2>"
```
*(Always pass messages directly via command arguments to avoid PowerShell BOM or escape issues).*
