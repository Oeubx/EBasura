# Badges, Milestones & Achievement System

## 1. Scope & Responsibility
Documents the criteria, data models, and user display components for collectible achievement badges.

---

## 2. Badge Data Model (`lib/backend/supabase/database/tables/badge.dart`)
Persisted in the Postgres `badge` table:
- `id`: Unique identifier (int/uuid).
- `name`: Display name (e.g. *"Recycling Pioneer"*, *"Eco Champion"*, *"Master Segregator"*).
- `description`: Summary of required criteria to earn the badge.
- `points_required`: Minimum point threshold required for auto-unlock.
- `badge_icon_url`: Supabase Storage URL hosting the badge vector/PNG asset.
- `created_at`: Timestamp.

---

## 3. Badge Presentation Screens

### 3.1 Badge Directory (`PBadgeViewAllWidget`)
- **Location**: `lib/admin/badges/p_badge_view_all/`
- **Route**: `/pBadgeViewAll`
- **Function**: Displays all available badges in the system, indicating locked vs. unlocked state for the current user.

### 3.2 Badge Detail View (`PBadgeViewOneWidget`)
- **Location**: `lib/admin/badges/p_badge_view_one/`
- **Route**: `/pBadgeViewOne`
- **Parameters**: `badgeRef` (`BadgeRow`).
- **Function**: Shows large badge graphic, lore description, required milestones, and date acquired.
