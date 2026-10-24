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
4. **Brand Design Compliance**: Verifies that UI changes strictly align with [`docs/design_system/brand_and_design_system.md`](../../docs/design_system/brand_and_design_system.md).
5. **Backlog-Linked Commits**: Verifies that commits adhere to Conventional Commits formatted via [`.agents/skills/git-commits/SKILL.md`](../git-commits/SKILL.md).

---

## How to Execute the Audit

Run the audit script from the root of the EBasura repository:

```powershell
python .agents/skills/staging-readiness-audit/audit_readiness.py
```

Inspect output and address any blocking issues before pushing upstream.
