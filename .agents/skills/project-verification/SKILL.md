---
name: project-verification
description: Standardized quality and regression verification runner for EBasura. Runs Flutter static analysis and unit/widget tests.
---

# EBasura Project Verification Skill

Use this skill after making code, dependency, or configuration changes to verify the project's health and integrity.

## Standard Verification Suite

Execute the following checks in order:

### 1. Static Analysis
Verify that no static analysis errors exist:
```powershell
flutter analyze
```

### 2. Formatting Check (Optional / CI)
Check if any Dart files deviate from canonical formatting:
```powershell
dart format --output=none --set-exit-if-changed lib test
```

### 3. Automated Tests
Run the test suite:
```powershell
flutter test
```

---

## Decision Matrix

- If **all pass**: State that the project is verified and ready for commit drafting.
- If **analyzer errors occur**: Hand off to `pr-check-fix` or fix the specific compiler/analyzer issues before proceeding.
- If **tests fail**: Report the failing test names and stack traces clearly.
