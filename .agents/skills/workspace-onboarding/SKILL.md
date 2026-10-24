---
name: workspace-onboarding
description: Fires on opener phrases like "work on EBasura" or "start working", loads project guidance, and emits a pre-flight environment check.
---

# EBasura Workspace Onboarding Skill

Use this skill when starting a new session or beginning work on EBasura.

## Pre-flight Checklist

1. Read `AGENTS.md` at the root of the workspace.
2. For any UI or frontend tasks, review `docs/design_system/brand_and_design_system.md`.
3. Verify Flutter SDK availability:
   ```powershell
   flutter --version
   ```
4. Check `env.json` existence:
   - Confirm `env.json` exists locally. If missing, advise copying from `env.json.example`.
5. Check Git status:
   ```powershell
   git status --short --branch
   ```
6. Remember: For any code changes produced during the session, invoke `.agents/skills/git-commits/SKILL.md` to draft backlog-linked commits.

## Pre-flight Output Block

Emit this concise status block before writing code or running large workflows:

```text
Loaded:
  project:       EBasura (Flutter + Supabase + Gemini AI)
  guidelines:    AGENTS.md
  brand docs:    docs/design_system/brand_and_design_system.md (for UI/Frontend)
  commit skill:  .agents/skills/git-commits/SKILL.md (for all code changes)
  branch:        <current_branch>
  env status:    <configured_or_missing_env.json>
  verify cmd:    flutter analyze && flutter test
Proceeding with task: <restated_task>
```
