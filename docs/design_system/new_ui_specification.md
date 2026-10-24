# EBasura New UI Comparison & Design Specification

> **Document Status**: Canonical New UI Comparative Specification (Part 2)  
> **Backlog Reference**: `[EBASURA-M0-F1]` (FlutterFlow Core Engine & Theme Provider) / `[EBASURA-M10-F2]` (Shared UI Components)  
> **Authority**: [`docs/design_system/brand_and_design_system.md`](brand_and_design_system.md) / [`docs/brand_docs.md`](brand_docs.md)  
> **Baseline Audit Reference**: [`docs/old_ui_audit.md`](old_ui_audit.md)

---

## 1. Executive Summary & Design Vision

This document establishes the official **New UI Specification** for EBasura in direct comparison with the baseline old UI documented in **Part 1**. 

Guided by the brand identity derived from the design board, this specification transforms EBasura from a fragmented prototype into a modern, accessible, and cohesive civic-tech mobile platform.

### Core Transformation Tenets
1. **Color Tokenization**: Eradicate all hardcoded hex literals (`#263B6A`, `#DFF1F1`, `#E8EDF2`) in favor of the 6 canonical brand tokens (`#2E78A6`, `#A3C9D9`, `#D5F2E2`, `#31A11F`, `#70BF5A`, `#F2F2F2`).
2. **Typographic Hierarchy**: Establish a clear separation of concerns between **Brand Identity** (`Comfortaa`) and **User Interface** (`Inter` / `Inter Tight`).
3. **Pill Component Geometry**: Unify all buttons, input chips, and status badges under the standardized **Buttons 1â€“4 pill system** (20.0pxâ€“22.0px corner radius) with subtle drop shadows (`FFShadows.sm` / `md`).
4. **Fluid, Responsive Containers**: Replace rigid, fixed-height boxes (`500px`, `525px`) with a responsive 16.0px base grid that adapts smoothly across all screen sizes.
5. **Role-Tailored Architecture**: Provide dedicated, persona-specific interfaces for **Residents**, **Guests**, **Collection Crews** (dedicated `/pageCrewDashboard` route), and **Administrators**.

---

## 2. Global Old UI vs. New UI Comparative Matrix

| Design Dimension | Old UI (Baseline / Debt) | New UI (Brand System Specification) | Architectural Rationale & User Benefit |
| :--- | :--- | :--- | :--- |
| **Color Spectrum** | Hardcoded `#263B6A`, `#DFF1F1`, `#E8EDF2`, `#6984A9`, `#A0D585`. | 6 Canonical Tokens: `#2E78A6` (Ocean Blue), `#A3C9D9` (Sky Blue), `#D5F2E2` (Mint Tint), `#31A11F` (Eco Green), `#70BF5A` (Leaf Green), `#F2F2F2` (Neutral Canvas). | Replaces muddy greys and unbranded blues with fresh, eco-civic colors that reinforce environmental action. |
| **Brand Identity** | Raster PNG banner (`Horizontal_Logo.png`) consuming 150px height. | Vector wordmark using **`Comfortaa`** (`FontWeight.w700`) + eco leaf badge icon (`Icons.eco_rounded`). | Crisp rendering at all pixel densities; recovers 100px+ of vertical viewport space on every screen. |
| **Interface Fonts** | Ad-hoc inline overrides chaining `.fontWeight` and `.fontStyle`. | **`Inter` / `Inter Tight`** type scale: `displayLarge` (64px), `headlineMedium` (28px), `titleMedium` (18px), `labelLarge` (16px), `bodyMedium` (14px), `bodySmall` (12px). | High x-height, tall apertures, maximum legibility on mobile screens, zero redundant style overrides. |
| **Button Geometry** | Rectangular with mismatched radii (8px, 10px, 12px, 15px, 75px). | **Pill Geometry (20.0pxâ€“22.0px radius)** across all buttons matching Buttons 1â€“4 specs. | Consistent touch targets, modern aesthetic, and instant visual affordance. |
| **Elevation & Depth** | Heavy `elevation: 15.0` on landing page; raw inline `BoxShadow`. | Standardized tokens: `FFShadows.sm` (blur 3px, dy 1px) and `FFShadows.md` (blur 6px, dy 3px) at 10% black opacity. | Soft, natural depth without dark visual clutter or rendering performance overhead. |
| **Container Sizing** | Fixed heights (`height: 500.0`, `height: 525.0`); random paddings (10, 14, 15, 25px). | **16px Fluid Grid System**: Auto-sizing `shrinkWrap` cards, 16.0px horizontal screen margins, 16.0px card radii. | Completely eliminates viewport clipping and double scrollbars across small phones and large tablets. |
| **Iconography** | Fragmented blend of Material Icons and FontAwesome (`Icons.person_3` + `FontAwesomeIcons.list`). | **Unified Material Symbols set** (20px / 24px) with semantic active (`#2E78A6`) and muted (`#4E4E4E`) color bindings. | Visual weight parity, consistent bounding boxes, and cohesive civic iconography. |
| **Navigation Dock** | 75px navy block with an oversized 125px camera FAB; broken guest bar. | **Sleek 68px floating dock** in `#FFFFFF` / `#F2F2F2`, 54px balanced camera FAB with green accent ring, dynamic 5-tab set per role. | Unobtrusive, thumb-friendly navigation that adapts seamlessly to the authenticated persona. |
| **Guest Persona** | Inconsistent teal bottom bar with black icons and an immediate logout button; no context. | **Transparent Guest Preview**: Identical structure to Resident view + top `#A3C9D9` Guest Banner + gentle auth bottom sheet. | Seamless, welcoming onboarding that lets users test the app before creating an account. |
| **Resident Persona** | Generic list; dark blue banner; personal points hidden in sub-text. | **Gamified Eco Hub (`/pageHomepage`)**: Eco points badge in `#D5F2E2` / `#70BF5A`, daily streak card, collection countdown badge. | Drives civic engagement and rewards verified recycling behaviors. |
| **Crew Persona** | Non-existent; crew members see standard resident screens. | **Dedicated Route (`/pageCrewDashboard`)**: Real-time shift toggle, street collection checklist, 1-tap route incident logger. | Purpose-built operational utility for collection truck drivers and sanitation workers. |
| **Admin Persona** | 5 plain teal boxes (`#DFF1F1`) without real-time metrics. | **Operations Command Center (`/pageAdminDashboard`)**: 4 KPI stat cards, moderation queue counter badge, and quick management pills. | Empowers barangay administrators with instant operational oversight and moderation efficiency. |

---

## 3. Screen-by-Screen Transformation Specifications

```
+-------------------------------------------------------------------------------+
|                            SCREEN TRANSFORMATION MAP                          |
+-------------------------------------------------------------------------------+
| 1. Landing & Auth Entry    -> From 15px shadows to Clean Canvas & Pill CTAs   |
| 2. Resident Dashboard      -> From static list to Gamified Eco Hub            |
| 3. Guest Mode Preview      -> From broken bar to Friendly Banner & Intercepts |
| 4. Leaderboard View        -> From 500px card to Fluid Rank Tier Cards        |
| 5. Schedules & Directory   -> From 525px container to Responsive Calendar Tabs|
| 6. Crew Field Dashboard    -> New Dedicated Route (/pageCrewDashboard)        |
| 7. Admin Command Center    -> From 5 teal boxes to Live KPI Operations Hub    |
| 8. Shared Bottom Dock      -> From 125px giant FAB to 68px Floating Nav Dock  |
+-------------------------------------------------------------------------------+
```

---

### 3.1. Landing Page (`LandingPageWidget` â€” `/landingPage`)

#### Old UI (Baseline)
- Background: Muddy grey `Color(0xFFE8EDF2)`.
- Header: 150px static PNG `Horizontal_Logo.png` with arbitrary padding `fromSTEB(0.0, 125.0, 0.0, 75.0)`.
- Buttons: Rectangular 8.0px radius, 50.0px height, with an excessive `elevation: 15.0`.
  - Sign Up: `Color(0xFF263B6A)`
  - Sign In: `Color(0xFF6984A9)`
  - View as Guest: `Color(0xFFA0D585)`

#### New UI (Specification)
- **Background**: Crisp `#F2F2F2` (Neutral Canvas).
- **Brand Header**: Reusable `EBasuraBrandLogo` widget:
  - Font: `Comfortaa`, 36.0px, `FontWeight.w700`, color `#013448`.
  - Accent: Leaf green badge (`#31A11F`) with subtitle *"Smart Community Waste Management"* in `Inter`, 14.0px.
- **Interactive Button Stack (Buttons 1â€“4 Pill System)**:
  - **Sign Up Button (Button 2 Spec)**:
    - Background: `#2E78A6` (Deep Ocean Blue)
    - Text: Pure White `#FFFFFF`, `Inter`, 16.0px, `FontWeight.w600`
    - Geometry: `width: 280.0`, `height: 48.0`, `borderRadius: BorderRadius.circular(22.0)`
    - Elevation: `FFShadows.md` (blur 6px, dy 3px, `Color(0x1A000000)`)
  - **Sign In Button (Button 1 Spec)**:
    - Background: `#FFFFFF` (Surface White) with 1px border `#A3C9D9`
    - Text: Deep Slate `#013448`, `Inter`, 16.0px, `FontWeight.w600`
    - Geometry: `width: 280.0`, `height: 48.0`, `borderRadius: BorderRadius.circular(22.0)`
    - Elevation: `FFShadows.sm` (blur 3px, dy 1px)
  - **View as Guest Button (Button 4 Spec)**:
    - Background: `#D5F2E2` (Mint Tint)
    - Text: Deep Slate `#013448`, `Inter`, 16.0px, `FontWeight.w600`
    - Geometry: `width: 280.0`, `height: 48.0`, `borderRadius: BorderRadius.circular(22.0)`
    - Elevation: `FFShadows.sm`

---

### 3.2. Resident Dashboard (`PageHomepageWidget` â€” `/pageHomepage`)

#### Old UI (Baseline)
- Screen wrapped in `Color(0xFFE8EDF2)` containing 150px static PNG logo.
- User greeting formatted in plain text with no visual container.
- Points balance displayed as raw number without tier level or streak context.
- No immediate indicator of next garbage collection pickup.

#### New UI (Specification)
- **Header Bar**:
  - Left: Compact wordmark `EBasura` in `Comfortaa` (22px).
  - Right: Quick profile avatar and notification bell (`Icons.notifications_outlined` in `#2E78A6`).
- **Hero Greeting Card**:
  - Background: Soft `#D5F2E2` (Mint Tint) with 16.0px radius.
  - Greeting: *"Hello, [User Name] ðŸ‘‹"* in `Inter Tight`, 20.0px bold (`#013448`).
  - Subtitle: *"Barangay Central â€¢ Street Zone 4"* in `Inter`, 13.0px (`#4E4E4E`).
- **Gamified Points & Streak Bar**:
  - Highlight Container: `#FFFFFF` card with `#31A11F` left border accent.
  - Points Tally: **`340 Eco Points`** highlighted in `#31A11F` bold.
  - Active Streak: Chip in `#70BF5A` (Leaf Green) with fire icon: *"5-Day Streak ðŸ”¥"*.
- **Next Collection Countdown Card**:
  - Background: `#FFFFFF` card with `FFShadows.sm`.
  - Left icon: `Icons.local_shipping_rounded` in a `#A3C9D9` circular badge.
  - Details: *"Next Pickup: Tomorrow, 8:00 AM â€¢ Biodegradable"*.
- **Primary Action (Scan Waste CTA â€” Button 2 Spec)**:
  - Full-width pill button: Background `#2E78A6`, icon `Icons.photo_camera_rounded`, label *"Scan Waste to Earn Points"*, 22.0px radius.

---

### 3.3. Guest Mode Experience (`PageHomepageWidget` in Guest Mode)

#### Old UI (Baseline)
- Completely altered bottom bar in `#DFF1F1` with black icons and an instant logout button.
- No banner indicating guest status; features fail or redirect abruptly.

#### New UI (Specification)
- **Visual Parity**: The guest view shares the **exact same layout, container structure, and card positions** as the Resident Dashboard to build familiarity.
- **Persistent Top Guest Banner**:
  - Background: Soft Sky Blue Tint (`#A3C9D9` with 12% opacity) with a solid `#A3C9D9` left indicator bar.
  - Content:
    - Icon: `Icons.info_outline_rounded` in `#2E78A6`.
    - Text: *"You are viewing in Guest Mode. Sign in or sign up to save points and earn badges."*
    - Action: Compact pill button (Button 3 spec) in `#A3C9D9` with text *"Sign In"*, navigating to `/pageSignIn`.
- **Preview Chips**:
  - Points Card displays sample state: *"Preview Mode â€” Earn up to +25 pts per scan"*.
- **Graceful Auth Intercept**:
  - When a guest completes a waste scan, the AI results are shown immediately (e.g. *"Recyclable: Plastic Bottle"*), followed by an attractive bottom sheet modal:
    - Title: *"Want to claim your +25 points?"* in `Comfortaa`.
    - CTAs: [Create Account] (Button 2 / Solid Blue) and [Continue Browsing] (Button 1 / Neutral).

---

### 3.4. Dedicated Crew Route (`PageCrewDashboardWidget` â€” `/pageCrewDashboard`)

#### Old UI (Baseline)
- **Zero interface existed**. Collection crew members were forced into the resident gamification dashboard.

#### New UI (Specification)
- **Route URL**: `/pageCrewDashboard` (Authorized via `RoleService.isCrew(userType)`).
- **Shift Status Bar**:
  - Header displaying: Truck ID (e.g. *"Truck #04 â€” Crew Lead: Roberto M."*).
  - Interactive Status Toggle: Pill chips for `[ Idle ]`, `[ En Route ]`, `[ In Progress ]`, `[ Completed ]` using `#2E78A6` active states.
- **Street Collection Checklist**:
  - Interactive card list of assigned streets for today's pickup schedule:
    - Card: Street Name (e.g., *"Rizal Avenue"*) + Scheduled Window (*"8:00 AM â€“ 10:00 AM"*).
    - Progress Meter: Visual indicator showing *4 / 6 Streets Completed* in `#31A11F`.
    - Action: Button 4 (Mint Eco Pill) labeled *"Mark Collected âœ“"*.
- **Quick Route Incident Logger**:
  - Button 3 (Sky Blue Pill) labeled *"Report Route Blockage / Hazard âš ï¸"*, opening a fast photo+note report dialog.
- **Center Scan Integration**:
  - The bottom bar center camera FAB routes directly to collection verification mode.

---

### 3.5. Admin Command Center (`PageAdminDashboardWidget` â€” `/pageAdminDashboard`)

#### Old UI (Baseline)
- 5 static full-width teal boxes (`#DFF1F1`) with black text and zero system metrics.

#### New UI (Specification)
- **Header**: `EBasura Admin Console` with active barangay jurisdiction badge.
- **Operational KPI Grid (2x2 Card Matrix)**:
  - Card 1: **Total Scans Today** (`#2E78A6` accent bar, count + percentage delta).
  - Card 2: **Recyclability Rate** (`#31A11F` accent bar, e.g. *74.2%*).
  - Card 3: **Pending Moderations** (`#F9CF58` warning badge, e.g. *12 Flagged Images*).
  - Card 4: **Active Collection Routes** (`#70BF5A` accent bar, e.g. *3 Trucks in Field*).
- **Quick Action Management Hub (Pill-Styled Cards)**:
  - Replaces the 5 plain teal boxes with styled cards containing Material Symbols, title, and descriptive subtitle:
    - **Image Moderation Queue**: Badge showing pending count, links to `/pImagesViewAllFlagged`.
    - **Collection Schedules**: Calendar manager, links to `/admin/dates/p_dates_view_all`.
    - **Street & Community Directory**: Zone and street manager, links to `/admin/street/p_street_view_all`.
    - **User & Crew Management**: Role assignment and directory, links to `/pageUserManagement`.
    - **Badges & Gamification Administration**: Points rules and badge awards, links to `/admin/badges/p_badge_view_all`.

---

### 3.6. Leaderboard & Gamification (`PageLeaderboardWidget` â€” `/pageLeaderboard`)

#### Old UI (Baseline)
- Hardcoded `height: 500.0` card with pale teal fill (`#DFF1F1`) and 25.0px radius.
- Flat text list without podium or tier badges.

#### New UI (Specification)
- **Auto-sizing Fluid Container**: Height scales to content and viewport; eliminates clipping.
- **Podium Display (Top 3 Recyclers)**:
  - 1st Place: Gold leaf badge in `#70BF5A`, elevated center avatar, points badge.
  - 2nd Place: Silver badge in `#A3C9D9`.
  - 3rd Place: Bronze badge in `#D5F2E2`.
- **Sticky Current User Rank Card**:
  - Pinned card at bottom of leaderboard: *"Your Rank: #14 â€¢ 340 pts â€¢ 20 pts to Level Up"*.
- **Guest State**:
  - Top 5 preview visible, user position displays friendly lock chip: *"Sign in to join the leaderboard"*.

---

### 3.7. Shared Bottom Navigation Dock (`CBottomBarWidget`)

#### Old UI (Baseline)
- 75.0px navy block (`#263B6A`) with an oversized 125.0px floating camera button.
- Incoherent icon libraries (`Icons.*` mixed with `FontAwesomeIcons.*`).
- Completely divergent bottom bar for guests with black icons and an immediate logout button.

#### New UI (Specification)
- **Dock Geometry**:
  - Height: **68.0px** (accommodates device safe areas).
  - Background: Crisp White (`#FFFFFF`) with 1px top border `#D5F2E2` and `FFShadows.md`.
  - Top corner radius: 18.0px.
- **Center Scan Action (Pill FAB)**:
  - Balanced **54.0px** circle elevated by 16px above dock line.
  - Fill: `#2E78A6` (Deep Ocean Blue) with pure white `Icons.photo_camera_rounded` (28.0px).
  - Glowing ring accent: 2.0px ring in `#31A11F` (Eco Green).
- **Dynamic 5-Tab Role Matrix**:
  - **Resident / Guest**:
    1. Dashboard (`Icons.space_dashboard_rounded`)
    2. Leaderboard (`Icons.leaderboard_rounded`)
    3. Center: AI Scan Camera
    4. Schedules & Guides (`Icons.calendar_today_rounded`)
    5. Profile / Auth (`Icons.person_rounded`)
  - **Collection Crew**:
    1. Route Dashboard (`Icons.local_shipping_rounded`)
    2. Street Checklist (`Icons.checklist_rounded`)
    3. Center: Collection Verification Scan
    4. Incident Alerts (`Icons.report_problem_rounded`)
    5. Crew Profile (`Icons.person_rounded`)
  - **Admin**:
    1. Admin Command Center (`Icons.admin_panel_settings_rounded`)
    2. Moderation Queue (`Icons.verified_user_rounded`)
    3. Center: Inspection Camera
    4. Schedules Manager (`Icons.calendar_month_rounded`)
    5. User Management (`Icons.group_rounded`)

---

## 4. Design System Token Mapping Reference

This table provides the exact replacement mapping from old legacy values to new design tokens:

| Old Legacy Value | New Design System Token | Hex / Value | Semantic Role |
| :--- | :--- | :--- | :--- |
| `Color(0xFF263B6A)` | `FlutterFlowTheme.accent3` / `brandBlue` | `#2E78A6` | Primary brand solid, prominent CTA buttons, primary tab active states. |
| `Color(0xFF6984A9)` | `FlutterFlowTheme.accent4` / `skyTint` | `#A3C9D9` | Secondary controls (Button 3), selected chips, card borders. |
| `Color(0xFFDFF1F1)` | `FlutterFlowTheme.secondaryBackground` | `#D5F2E2` | Pale Mint Sage: Card backdrops, soft button backgrounds (Button 4). |
| `Color(0xFFA0D585)` | `FlutterFlowTheme.ecoSecondary` | `#70BF5A` | Fresh Leaf Green: Gamification points, streaks, organic categories. |
| *(None - Missing)* | `FlutterFlowTheme.ecoPrimary` | `#31A11F` | Vibrant Eco Green: Recyclable badges, verified records, eco CTAs. |
| `Color(0xFFE8EDF2)` | `FlutterFlowTheme.primaryBackground` | `#F2F2F2` | Clean Canvas Neutral: Default screen surface, scaffold base (Button 1). |
| `Color(0xFF000000)` (text) | `FlutterFlowTheme.primaryText` | `#013448` | Deep slate charcoal text providing WCAG AAA compliance on light surfaces. |
| `BorderRadius.circular(8.0)` | `FFRadius.pill` | `22.0px` | Standardized pill geometry for all buttons (Buttons 1â€“4). |
| `elevation: 15.0` | `FFShadows.sm` / `FFShadows.md` | `blur: 3 / 6` | Subtle, clean elevation with 10% black opacity (`Color(0x1A000000)`). |
| `buttonSize: 125.0` | Standardized Camera FAB | `54.0px` | Balanced center floating action button. |
| `height: 500.0 / 525.0` | Fluid responsive layout | Auto (`shrinkWrap`) | Eliminates fixed-height container clipping. |

---

## 5. Accessibility & Contrast Verification (WCAG 2.1)

| UI Element Pairing | Foreground | Background | Contrast Ratio | Baseline (Old) | Target (New) | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Primary Text on Canvas** | `#013448` | `#F2F2F2` | **11.4:1** | Muddy `#E8EDF2` (7.2:1) | Crisp `#F2F2F2` (11.4:1) | PASS (WCAG AAA) |
| **White Text on Primary CTA** | `#FFFFFF` | `#2E78A6` | **4.9:1** | Dark `#263B6A` (7.8:1) | `#2E78A6` (4.9:1) | PASS (WCAG AA Normal) |
| **Primary Text on Mint Card** | `#013448` | `#D5F2E2` | **10.1:1** | Teal `#DFF1F1` (9.5:1) | Mint `#D5F2E2` (10.1:1) | PASS (WCAG AAA) |
| **Primary Text on Sky Blue** | `#013448` | `#A3C9D9` | **7.8:1** | Steel `#6984A9` (3.4:1 FAIL) | Sky `#A3C9D9` (7.8:1 PASS) | PASS (WCAG AAA) |
| **White on Vibrant Eco Green** | `#FFFFFF` | `#31A11F` | **3.6:1** | *(Missing)* | Large text / Bold (>= 18px) | PASS (WCAG AA Large) |

---

## 6. Migration Sequence into Part 3 (Implementation)

With Part 1 (Baseline Audit) and Part 2 (New UI Specification) completed, the implementation roadmap directly follows the 7 structured phases in Part 3:

```
[Part 1: Old UI Audit] -> [Part 2: New UI Specification] -> [Part 3: Phased Implementation]
                                                                  |
              +---------------------------------------------------+
              |--> Phase 1: Theme Engine Tokens (FlutterFlowTheme)
              |--> Phase 2: Comfortaa Logo & Inter Typography
              |--> Phase 3: Core UI Component Library (Buttons 1-4, Icons, Cards)
              |--> Phase 4: Shared Navigation Overhaul (CBottomBarWidget)
              |--> Phase 5: Resident & Guest Experience (/pageHomepage)
              |--> Phase 6: Dedicated Crew Route (/pageCrewDashboard) & Admin Console
              |--> Phase 7: Verification, QA & Conventional Commits
```
