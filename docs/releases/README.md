# EBasura Release History & APK Distribution Catalog

This directory contains the master release log, version history, and offline distribution archives for the **EBasura** (AEBasura) mobile application.

---

## 1. Distribution Architecture

EBasura is distributed primarily through **offline APK sideloading and file sharing** (via USB, Google Drive, or messaging apps) rather than app stores:
- **Compiled Binaries**: Stored locally on disk at `releases/v<version>/EBasura-v<version>-release.apk` (gitignored to keep the repository lightweight).
- **Online Integrations**: Standalone APKs connect to cloud services (Supabase Database/Auth/Storage and Google Gemini Vision API) using credentials bundled from `env.json`.
- **Version Documentation**: Every release has a dedicated, detailed change log in [`versions/`](versions/).

---

## 2. Master Release Catalog

| Version | Build Date | Commit Hash | APK Local Path | SHA-256 Checksum | Detailed Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| *Initial setup* | — | — | `releases/v1.0.0+1/` | — | [`versions/v1.0.0+1.md`](versions/v1.0.0+1.md) |
| `v1.0.0+1` | 2026-09-20 | `020e903` | `releases/v1.0.0+1/` | `N/A (Dry run...` | [`versions/v1.0.0+1.md`](versions/v1.0.0+1.md) |

*(Entries are automatically appended by the `apk-release` skill upon compilation).*

---

## 3. End-User Installation / Sideloading Guide

To install an EBasura release APK on an Android device:

1. **Transfer the APK**: Copy `EBasura-v<version>-release.apk` to the target Android device via USB cable, Google Drive, Bluetooth, or messaging app.
2. **Enable Unknown Apps**:
   - Navigate to **Settings** > **Security & Privacy** (or **Apps** > **Special App Access**).
   - Select **Install unknown apps**.
   - Enable permission for the browser, file manager, or Drive app used to open the APK.
3. **Install & Launch**:
   - Tap the `.apk` file and select **Install**.
   - If prompted by Google Play Protect with an "Unrecognized app" dialog, tap **More details** > **Install anyway** (standard for non-Play Store sideloaded applications).
4. **Permissions**:
   - Grant **Camera** permission when prompted (required for waste scanning).
   - Grant **Internet** access (required for Gemini AI analysis and Supabase sync).
