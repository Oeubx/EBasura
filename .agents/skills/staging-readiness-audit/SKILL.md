---
name: staging-readiness-audit
description: Audits repository readiness before pushing or merging. Checks branch drift, secret leaks (env.json/Gemini keys), and Flutter code analysis.
---

# EBasura Staging & Pre-Push Readiness Audit Skill

Use this skill whenever you are preparing to push changes, merge into the main branch, or open a pull request.

## Verification Gates Covered

1. **Git Branch & Drift**: Checks working tree status, uncommitted modifications, and upstream ahead/behind counts.
2. **Secret & Gitignore Shield**: Verifies `env.json` is untracked and scans for hardcoded Google Gemini API keys (`AIzaSy...`) or Supabase keys.
3. **Flutter Analyze Integrity**: Verifies Flutter static analysis passes without fatal errors.

---

## How to Execute the Audit

Run the audit script from the root of the EBasura repository:

```powershell
python .agents/skills/staging-readiness-audit/audit_readiness.py
```

## Result Decisions

- **GREEN LIGHT**: 100% clean and ready to commit, push, or open a PR.
- **AMBER LIGHT**: Warnings detected (e.g., uncommitted changes, non-fatal analyzer hints, or commits behind remote). Review before proceeding.
- **RED LIGHT**: Blockers detected (e.g., fatal Flutter analyze errors, tracked `env.json`, or leaked API keys). **Must resolve before pushing.**
