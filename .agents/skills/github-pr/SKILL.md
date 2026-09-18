---
name: github-pr
description: Creates GitHub branches, pushes, and pull requests for the EBasura repository. Use when the user asks to create a branch, push to remote, or open/create a pull request.
---

# EBasura GitHub PR Skill

Use this skill to create branches, push code, and generate structured pull requests for `Oeubx/EBasura`.

## Delivery Conventions

### 1. Branch Naming
Always follow the `<type>/<scope>/<feature>` pattern:
- Examples:
  - `feat/gemini/injection-guard`
  - `fix/auth/session-timeout`
  - `chore/deps/upgrade-supabase`
- Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `ci`.
- Scopes: `auth`, `gemini`, `waste-scan`, `gamification`, `schedule`, `streets`, `supabase`, `ui`, `deps`, `root`.

### 2. Preflight Checks
Before preparing or creating a PR:
1. Check GitHub CLI availability:
   ```powershell
   gh --version
   gh auth status
   ```
2. Verify active branch and status:
   ```powershell
   git status --short
   git branch --show-current
   ```
3. Fetch remote branches to verify target base (e.g., `development`, `main`):
   ```powershell
   git fetch origin
   ```

---

## PR Creation Flow

### 1. Inspect Changed Files & Commits
```powershell
git log origin/main..HEAD --oneline
git diff --stat origin/main..HEAD
```

### 2. Prepare PR Body from Template
Fill `.agents/skills/github-pr/templates/pr-body.md` using UTF-8 without BOM encoding:
- **Overview**: 2-3 sentence summary of the primary change.
- **Notable Changes**: Concise past-tense bullets describing the diff.
- **Commits**: Verbatim `git log --reverse --oneline origin/<base>..HEAD`.
- **Tests Run**: List verification steps performed (e.g., `flutter analyze`, `flutter test`).

### 3. Create PR via GitHub CLI
Write the body content to a temporary UTF-8 file to prevent PowerShell backtick interpretation issues, then invoke `gh`:
```powershell
gh pr create --repo Oeubx/EBasura --base main --head <branch-name> --title "<PR Title>" --body-file "<path-to-body.md>"
```

### 4. Safety Mandate
- **NEVER** push or create a PR without explicit user instruction.
- **NEVER** include sensitive tokens, passwords, or `env.json` secrets in the PR body.
