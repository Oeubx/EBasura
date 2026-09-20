# EBasura Release History & APK Distribution Catalog

This directory contains the canonical release logs, version progression, and offline distribution manifests for the **EBasura** (AEBasura) mobile application.

---

## 1. Distribution Architecture

EBasura is distributed primarily through **offline APK sharing and sideloading** (via USB, Google Drive, Bluetooth, or messaging apps) rather than public app stores:
- **Compiled Binaries**: Stored locally on disk at `releases/v<version>/EBasura-v<version>-release.apk` (gitignored to keep the repository lightweight).
- **Online Integrations**: Standalone APKs connect to cloud services (Supabase Database/Auth/Storage and Google Gemini Vision API) using credentials bundled from `env.json`.
- **Version Documentation**: Every release has a dedicated, detailed change log in [`versions/`](versions/).

---

## 2. Version Evolution Overview

The lifecycle of the application is defined across three distinct evolutionary milestones:

| Milestone | Semantic Version | Focus / Description | Detailed Specification |
| :--- | :--- | :--- | :--- |
| **Version 1** | `1.0.0+1` | **Initial Core Application (Pre-Emerging Technology)**: Core FlutterFlow UI, Supabase tables, authentication, manual reporting, schedules, and street directory without AI models. | [`versions/v1.0.0+1.md`](versions/v1.0.0+1.md) |
| **Version 2** | `2.0.0+1` | **Emerging Technology Integration**: Multimodal Google Gemini AI vision classification (`gemini-2.5-flash`, `gemini-flash-latest`), 5-attribute evaluation, gamified points, and visual prompt injection defense. | [`versions/v2.0.0+1.md`](versions/v2.0.0+1.md) |
| **Version 3** | `3.0.0+1` | **Current State**: Complete 11-module technical documentation framework, sprint backlog catalog, developer skills suite, and automated offline APK packaging and distribution runner. | [`versions/v3.0.0+1.md`](versions/v3.0.0+1.md) |

---

## 3. Master Release Catalog

| Version | Release Milestone | Release Date | Local Archive Path | SHA-256 Checksum | Detailed Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `v1.0.0+1` | Initial App (Pre-AI) | 2026-07-01 | `releases/v1.0.0+1/` | Baseline Initial Build | [`versions/v1.0.0+1.md`](versions/v1.0.0+1.md) |
| `v2.0.0+1` | Emerging Tech (Gemini AI) | 2026-08-15 | `releases/v2.0.0+1/` | Gemini AI Integration | [`versions/v2.0.0+1.md`](versions/v2.0.0+1.md) |
| `v3.0.0+1` | Current Architecture | 2026-09-20 | `releases/v3.0.0+1/` | Standalone Offline Suite | [`versions/v3.0.0+1.md`](versions/v3.0.0+1.md) |

---

## 4. End-User Installation & Sideloading Guide

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
