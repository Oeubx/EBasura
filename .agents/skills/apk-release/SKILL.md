---
name: apk-release
description: Compiles, packages, versions, and documents standalone release APKs for offline sharing and sideloading without app store distribution.
---

# EBasura APK Release & Offline Distribution Skill

Use this skill whenever the user asks to **build an APK**, **generate a release APK**, **package an APK**, or **prepare an offline release** for `EBasura`.

## Operational Context

EBasura is distributed primarily offline via **direct APK sharing and sideloading** (USB, Google Drive, messaging apps). While cloud services (Supabase & Google Gemini API) are connected online, the client itself is not deployed to the Google Play Store or served via the web.

---

## Pre-requisites & Verification Gate

Before running the release build:

1. **Staging Readiness Audit**: Confirm that `staging-readiness-audit` has run and reported **GREEN LIGHT** (0 analyzer errors, clean secret shield, no hardcoded API keys).
2. **Environment Validation**: Ensure `env.json` exists at the project root with valid Supabase and Google Gemini credentials.

---

## How to Execute the Release

### 1. Automated Execution via Helper Script
Run the automated packaging runner from the root of the repository:

- **Standard Build (increment build number, e.g. `1.0.0+1` $\to$ `1.0.0+2`)**:
  ```powershell
  python .agents/skills/apk-release/build_apk_release.py --bump
  ```

- **Explicit Version Override (e.g. `1.1.0+3`)**:
  ```powershell
  python .agents/skills/apk-release/build_apk_release.py --version 1.1.0+3
  ```

- **Dry-Run (test version bumping and documentation without compiling)**:
  ```powershell
  python .agents/skills/apk-release/build_apk_release.py --skip-build --bump
  ```

---

## What the Skill Produces

1. **Local Binary Archive (Gitignored)**:
   - File: `releases/v<version>/EBasura-v<version>-release.apk`
   - Stored strictly on local disk; ignored by Git to prevent repository bloat.
2. **Dedicated Version Documentation (Tracked in Git)**:
   - File: `docs/releases/versions/v<version>.md`
   - Records version number, build timestamp, commit hash, file size, SHA-256 integrity hash, included changes, and sideloading instructions.
3. **Master Release Catalog Update (Tracked in Git)**:
   - Appends the release row to the catalog table in `docs/releases/README.md`.
4. **Version Manifest Update**:
   - Updates `version:` in `pubspec.yaml`.

---

## Post-Build Verification & Hand-off

After the release completes:
1. Verify the generated APK file exists at `releases/v<version>/EBasura-v<version>-release.apk`.
2. Present the user with:
   - Local APK path
   - APK file size and SHA-256 hash
   - Link to the version release document (`docs/releases/versions/v<version>.md`)
3. Hand off to `git-commits` to commit the documentation and `pubspec.yaml` changes using the backlog code:
   ```text
   chore(release): prepared v<version> offline apk release [EBASURA-M0-F0]
   ```
