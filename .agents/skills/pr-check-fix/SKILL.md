---
name: pr-check-fix
description: Diagnoses and fixes failing checks (analyzer, formatting, tests) on open pull requests or branches, then updates the branch.
---

# EBasura PR Check Fix Skill

Use this skill when CI checks or local quality gates fail on an active branch or pull request.

## Common Check Failures in EBasura

1. **Flutter Analyzer Failures**:
   ```powershell
   flutter analyze
   ```
   - Common causes: unused imports, deprecated widget properties, null-safety issues, invalid type conversions.
2. **Dart Formatting Issues**:
   ```powershell
   dart format --output=none --set-exit-if-changed .
   ```
   - Automatically format all files:
   ```powershell
   dart format .
   ```
3. **Flutter Test Failures**:
   ```powershell
   flutter test
   ```

---

## Workflow

1. **Diagnose**: Run `flutter analyze` and `flutter test` locally to reproduce the reported issue.
2. **Implement Minimal Fix**: Modify only the affected files to resolve the failure without unnecessary refactoring.
3. **Verify**: Rerun the checks to verify they pass completely.
4. **Draft Repair Commit**: Present a clean fix commit (e.g. `fix(ui): resolve deprecated widget property in scan view`) following the `git-commits` convention.
5. **Wait for Approval**: Obtain user consent before committing and pushing the fix.
