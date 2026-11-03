import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/page_leaderboard/page_leaderboard_widget.dart';
import 'package:a_e_basura/backend/supabase/database/database.dart';

void main() {
  group('Phase 10: Leaderboard v2 (Periodic, Streets & Privacy) Unit Tests', () {
    // ------------------------------------------------------------------------
    // 1. Resident Leaderboard Entry Parsing & Fallbacks
    // ------------------------------------------------------------------------
    test('ResidentLeaderboardEntry parses complete RPC payload correctly', () {
      final rawMap = {
        'rank': 1,
        'user_id': '33333333-3333-3333-3333-333333333333',
        'display_name': 'Maria Santos',
        'avatar_url': 'https://example.com/avatar.png',
        'points': 145,
        'street_ref': 'Commonwealth Ave',
        'is_current_user': true,
      };

      final entry = ResidentLeaderboardEntry.fromMap(rawMap);

      expect(entry.rank, equals(1));
      expect(entry.userId, equals('33333333-3333-3333-3333-333333333333'));
      expect(entry.displayName, equals('Maria Santos'));
      expect(entry.avatarUrl, equals('https://example.com/avatar.png'));
      expect(entry.points, equals(145));
      expect(entry.streetRef, equals('Commonwealth Ave'));
      expect(entry.isCurrentUser, isTrue);
    });

    test('ResidentLeaderboardEntry provides robust defaults for missing fields', () {
      final rawMap = <String, dynamic>{
        'rank': null,
        'user_id': null,
        'display_name': null,
        'avatar_url': null,
        'points': null,
        'street_ref': null,
        'is_current_user': null,
      };

      final entry = ResidentLeaderboardEntry.fromMap(rawMap);

      expect(entry.rank, equals(0));
      expect(entry.userId, isEmpty);
      expect(entry.displayName, equals('Eco Resident'));
      expect(entry.avatarUrl, isNull);
      expect(entry.points, equals(0));
      expect(entry.streetRef, equals('Batasan Hills'));
      expect(entry.isCurrentUser, isFalse);
    });

    // ------------------------------------------------------------------------
    // 2. Leaderboard Privacy Display Masking
    // ------------------------------------------------------------------------
    test('Simulates privacy name masking rules based on leaderboard_display setting', () {
      String resolveDisplayName({
        required String rawName,
        required String privacySetting,
        required int rank,
      }) {
        switch (privacySetting) {
          case 'hidden':
            return 'Anonymous Resident';
          case 'initials':
            return rawName.isNotEmpty ? '${rawName[0]}.' : 'E.';
          case 'full_name':
          default:
            return rawName.isNotEmpty ? rawName : 'Eco Resident #$rank';
        }
      }

      // 1. Full Name
      expect(
        resolveDisplayName(rawName: 'Juan Dela Cruz', privacySetting: 'full_name', rank: 4),
        equals('Juan Dela Cruz'),
      );

      // 2. Initials Only
      expect(
        resolveDisplayName(rawName: 'Juan Dela Cruz', privacySetting: 'initials', rank: 4),
        equals('J.'),
      );

      // 3. Anonymous
      expect(
        resolveDisplayName(rawName: 'Juan Dela Cruz', privacySetting: 'hidden', rank: 4),
        equals('Anonymous Resident'),
      );

      // 4. Fallback for empty name
      expect(
        resolveDisplayName(rawName: '', privacySetting: 'initials', rank: 4),
        equals('E.'),
      );
    });

    // ------------------------------------------------------------------------
    // 3. Street Leaderboard Entry & Points Per Resident Calculation
    // ------------------------------------------------------------------------
    test('StreetLeaderboardEntry parses RPC map and points per resident correctly', () {
      final rawMap = {
        'rank': 1,
        'street_ref': 'Kalayaan B',
        'total_points': 520,
        'active_residents': 13,
        'points_per_resident': 40.0,
      };

      final entry = StreetLeaderboardEntry.fromMap(rawMap);

      expect(entry.rank, equals(1));
      expect(entry.streetRef, equals('Kalayaan B'));
      expect(entry.totalPoints, equals(520));
      expect(entry.activeResidents, equals(13));
      expect(entry.pointsPerResident, equals(40.0));
    });

    test('Street fairness metric prevents division by zero for streets with 0 active residents', () {
      double calculatePointsPerResident(int totalPoints, int activeResidents) {
        final divisor = activeResidents < 1 ? 1 : activeResidents;
        return double.parse((totalPoints / divisor).toStringAsFixed(2));
      }

      // Standard street calculation
      expect(calculatePointsPerResident(300, 10), equals(30.0));

      // Small street with high engagement outscores large street with low participation
      final smallStreetScore = calculatePointsPerResident(150, 3); // 50 pts/resident
      final largeStreetScore = calculatePointsPerResident(400, 20); // 20 pts/resident
      expect(smallStreetScore > largeStreetScore, isTrue);

      // Edge case: 0 active residents safely defaults to divisor 1
      expect(calculatePointsPerResident(0, 0), equals(0.0));
    });

    // ------------------------------------------------------------------------
    // 4. Pinned Rank & Deficit Calculation
    // ------------------------------------------------------------------------
    test('UserRankSummary parses data and calculates points required to overtake next rank', () {
      final rawMap = {
        'my_rank': 5,
        'my_points': 80,
        'points_to_next': 15,
      };

      final summary = UserRankSummary.fromMap(rawMap);

      expect(summary.rank, equals(5));
      expect(summary.points, equals(80));
      expect(summary.pointsToNext, equals(15));

      // Rank 1 requires 0 points to overtake
      final rank1Map = {
        'my_rank': 1,
        'my_points': 250,
        'points_to_next': 0,
      };
      final rank1Summary = UserRankSummary.fromMap(rank1Map);
      expect(rank1Summary.pointsToNext, equals(0));
    });

    // ------------------------------------------------------------------------
    // 5. UserSubtableRow Privacy and Streak Extensions
    // ------------------------------------------------------------------------
    test('UserSubtableRow exposes leaderboard_display and gamification fields', () {
      final row = UserSubtableRow({
        'user_idRef': '11111111-1111-1111-1111-111111111111',
        'user_points': 120,
        'current_streak': 3,
        'best_streak': 7,
        'freeze_available': true,
        'freeze_used_month': '2026-11',
        'spendable_points': 95,
        'leaderboard_display': 'initials',
      });

      expect(row.userIdRef, equals('11111111-1111-1111-1111-111111111111'));
      expect(row.userPoints, equals(120));
      expect(row.currentStreak, equals(3));
      expect(row.bestStreak, equals(7));
      expect(row.freezeAvailable, isTrue);
      expect(row.freezeUsedMonth, equals('2026-11'));
      expect(row.spendablePoints, equals(95));
      expect(row.leaderboardDisplay, equals('initials'));
    });
  });
}
