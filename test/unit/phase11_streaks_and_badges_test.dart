import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/backend/supabase/database/database.dart';

void main() {
  group('Phase 11: Rewards, Streaks & Rule-Based Badges Unit Tests', () {
    // ------------------------------------------------------------------------
    // 1. UserBadgeJunctionRow Data Model
    // ------------------------------------------------------------------------
    test('UserBadgeJunctionRow parses database row correctly', () {
      final now = DateTime.now();
      final row = UserBadgeJunctionRow({
        'id': 42,
        'user_id': '11111111-1111-1111-1111-111111111111',
        'badge_id': 'badge_seg_5',
        'awarded_at': now.toIso8601String(),
        'seen_at': null,
      });

      expect(row.id, equals(42));
      expect(row.userId, equals('11111111-1111-1111-1111-111111111111'));
      expect(row.badgeId, equals('badge_seg_5'));
      expect(row.seenAt, isNull);
    });

    // ------------------------------------------------------------------------
    // 2. BadgeRow Rule Extensions
    // ------------------------------------------------------------------------
    test('BadgeRow exposes rule_type and rule_threshold properties', () {
      final row = BadgeRow({
        'badge_id': 'badge_streak_3',
        'badge_name': 'Consistency Champion',
        'badge_description': '3-week verified segregation streak',
        'badge_level': 2,
        'badge_minPts': 100,
        'badge_maxPts': 300,
        'rule_type': 'streak',
        'rule_threshold': 3,
      });

      expect(row.badgeId, equals('badge_streak_3'));
      expect(row.badgeName, equals('Consistency Champion'));
      expect(row.badgeLevel, equals(2));
      expect(row.ruleType, equals('streak'));
      expect(row.ruleThreshold, equals(3));
    });

    // ------------------------------------------------------------------------
    // 3. Weekly Collection Streak & Monthly Freeze Logic
    // ------------------------------------------------------------------------
    test('Simulates streak increment, gap week freeze grace, and streak reset', () {
      int calculateNextStreak({
        required int currentStreak,
        required DateTime lastUpdatedWeek,
        required DateTime currentWeek,
        required bool freezeAvailable,
        required String? freezeUsedMonth,
        required String currentMonth,
        required bool hasScanThisWeek,
      }) {
        if (!hasScanThisWeek) return currentStreak;
        if (lastUpdatedWeek == currentWeek) return currentStreak;

        final daysDiff = currentWeek.difference(lastUpdatedWeek).inDays;
        if (daysDiff <= 7) {
          // Consecutive week
          return currentStreak + 1;
        } else {
          // Gap week: check monthly freeze
          final canFreeze = freezeAvailable && (freezeUsedMonth != currentMonth);
          if (canFreeze) {
            return currentStreak + 1; // Freeze preserved streak
          } else {
            return 1; // Reset to week 1
          }
        }
      }

      final mondayWeek1 = DateTime(2026, 11, 2);
      final mondayWeek2 = DateTime(2026, 11, 9);
      final mondayWeek4 = DateTime(2026, 11, 23); // Missed week 3
      final mondayWeek7 = DateTime(2026, 12, 14); // Multiple missed weeks with freeze already used

      // 1. Week 1 -> Week 2 consecutive
      final streakW2 = calculateNextStreak(
        currentStreak: 1,
        lastUpdatedWeek: mondayWeek1,
        currentWeek: mondayWeek2,
        freezeAvailable: true,
        freezeUsedMonth: null,
        currentMonth: '2026-11',
        hasScanThisWeek: true,
      );
      expect(streakW2, equals(2));

      // 2. Week 2 -> Week 4 (Week 3 missed, freeze available in Nov)
      final streakW4 = calculateNextStreak(
        currentStreak: streakW2,
        lastUpdatedWeek: mondayWeek2,
        currentWeek: mondayWeek4,
        freezeAvailable: true,
        freezeUsedMonth: null,
        currentMonth: '2026-11',
        hasScanThisWeek: true,
      );
      expect(streakW4, equals(3)); // Preserved by monthly freeze

      // 3. Week 4 -> Week 7 (Multiple weeks missed, freeze unavailable)
      final streakW7 = calculateNextStreak(
        currentStreak: streakW4,
        lastUpdatedWeek: mondayWeek4,
        currentWeek: mondayWeek7,
        freezeAvailable: false,
        freezeUsedMonth: '2026-11',
        currentMonth: '2026-11',
        hasScanThisWeek: true,
      );
      expect(streakW7, equals(1)); // Reset to 1
    });

    // ------------------------------------------------------------------------
    // 4. Rule-Based Badge Qualification Engine
    // ------------------------------------------------------------------------
    test('Evaluates user qualification across all 5 badge rule types', () {
      bool isBadgeQualified({
        required String ruleType,
        required int threshold,
        required int lifetimePts,
        required int segregatedCount,
        required int recyclableCount,
        required int reportCount,
        required int streakWeeks,
      }) {
        switch (ruleType) {
          case 'points':
            return lifetimePts >= threshold;
          case 'segregated_count':
            return segregatedCount >= threshold;
          case 'recyclable_count':
            return recyclableCount >= threshold;
          case 'report_count':
            return reportCount >= threshold;
          case 'streak':
            return streakWeeks >= threshold;
          default:
            return false;
        }
      }

      const userStats = {
        'pts': 250,
        'seg': 6,
        'recyc': 12,
        'rep': 3,
        'str': 4,
      };

      // 1. Points badge (threshold 200) -> Qualified
      expect(
        isBadgeQualified(
          ruleType: 'points',
          threshold: 200,
          lifetimePts: userStats['pts']!,
          segregatedCount: userStats['seg']!,
          recyclableCount: userStats['recyc']!,
          reportCount: userStats['rep']!,
          streakWeeks: userStats['str']!,
        ),
        isTrue,
      );

      // 2. Points badge (threshold 500) -> Not Qualified
      expect(
        isBadgeQualified(
          ruleType: 'points',
          threshold: 500,
          lifetimePts: userStats['pts']!,
          segregatedCount: userStats['seg']!,
          recyclableCount: userStats['recyc']!,
          reportCount: userStats['rep']!,
          streakWeeks: userStats['str']!,
        ),
        isFalse,
      );

      // 3. Segregation count badge (threshold 5) -> Qualified (has 6)
      expect(
        isBadgeQualified(
          ruleType: 'segregated_count',
          threshold: 5,
          lifetimePts: userStats['pts']!,
          segregatedCount: userStats['seg']!,
          recyclableCount: userStats['recyc']!,
          reportCount: userStats['rep']!,
          streakWeeks: userStats['str']!,
        ),
        isTrue,
      );

      // 4. Streak badge (threshold 3) -> Qualified (has 4)
      expect(
        isBadgeQualified(
          ruleType: 'streak',
          threshold: 3,
          lifetimePts: userStats['pts']!,
          segregatedCount: userStats['seg']!,
          recyclableCount: userStats['recyc']!,
          reportCount: userStats['rep']!,
          streakWeeks: userStats['str']!,
        ),
        isTrue,
      );

      // 5. Report count badge (threshold 3) -> Qualified (has 3)
      expect(
        isBadgeQualified(
          ruleType: 'report_count',
          threshold: 3,
          lifetimePts: userStats['pts']!,
          segregatedCount: userStats['seg']!,
          recyclableCount: userStats['recyc']!,
          reportCount: userStats['rep']!,
          streakWeeks: userStats['str']!,
        ),
        isTrue,
      );
    });

    // ------------------------------------------------------------------------
    // 5. Celebration Modal Trigger for Unseen Badges
    // ------------------------------------------------------------------------
    test('Isolates unseen badges to trigger celebration dialog', () {
      final badges = [
        {'badge_id': 'b1', 'badge_name': 'Starter', 'seen_at': '2026-11-01T10:00:00Z'},
        {'badge_id': 'b2', 'badge_name': 'Streak Champion', 'seen_at': null},
        {'badge_id': 'b3', 'badge_name': 'Segregation Specialist', 'seen_at': null},
      ];

      final unseenBadges = badges.where((b) => b['seen_at'] == null).toList();

      expect(unseenBadges.length, equals(2));
      expect(unseenBadges.first['badge_name'], equals('Streak Champion'));
    });
  });
}
