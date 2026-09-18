---
name: workspace-onboarding
description: Fires on opener phrases like "work on EBasura" or "start working", loads project guidance, and emits a pre-flight environment check.
---

# EBasura Workspace Onboarding Skill

Use this skill when starting a new session or beginning work on EBasura.

## Pre-flight Checklist

1. Read `AGENTS.md` at the root of the workspace.
2. Verify Flutter SDK availability:
   ```powershell
   flutter --version
   ```
3. Check `env.json` existence:
   - Confirm `env.json` exists locally. If missing, advise copying from `env.json.example`.
4. Check Git status:
   ```powershell
   git status --short --branch
   ```

## Pre-flight Output Block

Emit this concise status block before writing code or running large workflows:

```text
Loaded:
  project:       EBasura (Flutter + Supabase + Gemini AI)
  guidelines:    AGENTS.md
  branch:        <current_branch>
  env status:    <configured_or_missing_env.json>
  verify cmd:    flutter analyze && flutter test
Proceeding with task: <restated_task>
```
