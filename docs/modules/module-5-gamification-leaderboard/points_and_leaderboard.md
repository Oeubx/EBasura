# Points Calculation Engine & Community Leaderboard

## 1. Scope & Responsibility
Documents the point calculation rules, ledger state updates in Supabase, and real-time community leaderboard ranking.

---

## 2. Points Awarding Heuristics

Users receive points for positive environmental actions:

| Action Event | Point Value | Conditions & Validation |
| :--- | :--- | :--- |
| **Valid Waste Scan** | `+10 pts` | `valid_waste_image == true` verified by Gemini API or verifier. |
| **Proper Waste Segregation** | `+15 pts` | Additional bonus if `segregated == true`. |
| **Recyclable Item Reported** | `+5 pts` | Item tagged with `recyclable == true`. |
| **Verified Waste Incident Report** | `+25 pts` | Community incident report approved by an administrator. |
| **Flagged / Rejected Scan** | `0 pts` | Prompt injection attempts or invalid images receive 0 points. |

State is persisted in `user_subtable`:
- `points`: Integer field tracking cumulative lifetime points.
- `user_id`: Foreign key referencing `user.id`.

---

## 3. Leaderboard Presentation (`PageLeaderboardWidget`)
- **Location**: `lib/page_leaderboard/`
- **Route**: `/pageLeaderboard`
- **UI Architecture**:
  - Queries `user_subtable` ordered by `points DESC`.
  - Top 3 Podium: Prominently showcases Gold (1st), Silver (2nd), and Bronze (3rd) leaders with badges and avatars.
  - Ranked List: Paginated list displaying rank number, user display name, avatar, and total score.
  - Current User Pin: Sticky footer pinning the active user's current rank and point deficit to the next rank tier.
