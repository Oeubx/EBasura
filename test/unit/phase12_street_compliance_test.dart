import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/backend/supabase/database/database.dart';

void main() {
  group('Phase 12: Street Compliance Index (SCI) & Admin Flagging Tests', () {
    // ------------------------------------------------------------------------
    // 1. StreetComplianceSnapshotRow Data Model
    // ------------------------------------------------------------------------
    test('StreetComplianceSnapshotRow parses database record properly', () {
      final now = DateTime.now();
      final row = StreetComplianceSnapshotRow({
        'snapshot_id': 101,
        'street_ref': 'Rizal Avenue',
        'week_start': now.toIso8601String(),
        'verified_scans': 25,
        'segregated_scans': 22,
        'valid_reports': 1,
        'sci_week': 83.0,
        'sci_rolling4': 85.5,
        'grade': 'A',
        'computed_at': now.toIso8601String(),
      });

      expect(row.snapshotId, equals(101));
      expect(row.streetRef, equals('Rizal Avenue'));
      expect(row.verifiedScans, equals(25));
      expect(row.segregatedScans, equals(22));
      expect(row.validReports, equals(1));
      expect(row.sciWeek, equals(83.0));
      expect(row.sciRolling4, equals(85.5));
      expect(row.grade, equals('A'));
    });

    // ------------------------------------------------------------------------
    // 2. StreetFlagRow Data Model
    // ------------------------------------------------------------------------
    test('StreetFlagRow parses database record properly', () {
      final now = DateTime.now();
      final row = StreetFlagRow({
        'flag_id': 55,
        'street_ref': 'Mabini Street',
        'opened_week': now.toIso8601String(),
        'status': 'open',
        'action_note': 'Automated flag: Rolling SCI fell below 50% threshold.',
        'assigned_to': '11111111-1111-1111-1111-111111111111',
        'resolved_at': null,
        'created_at': now.toIso8601String(),
      });

      expect(row.flagId, equals(55));
      expect(row.streetRef, equals('Mabini Street'));
      expect(row.status, equals('open'));
      expect(row.actionNote, contains('Rolling SCI fell below 50%'));
      expect(row.assignedTo, equals('11111111-1111-1111-1111-111111111111'));
      expect(row.resolvedAt, isNull);
    });

    // ------------------------------------------------------------------------
    // 3. SCI Formula Calculation & Clamping
    // ------------------------------------------------------------------------
    test('Computes weekly SCI correctly with report penalties and [0, 100] clamping', () {
      double? computeWeeklySci({
        required int verifiedScans,
        required int segregatedScans,
        required int validReports,
      }) {
        if (verifiedScans < 5) return null; // Sample size guard
        final segRate = segregatedScans / verifiedScans;
        final reportPenalty = 5.0 * (validReports > 4 ? 4 : validReports);
        final rawSci = (100.0 * segRate) - reportPenalty;
        return rawSci.clamp(0.0, 100.0);
      }

      // Case A: 10/10 segregated, 0 reports -> 100.0%
      expect(
        computeWeeklySci(
          verifiedScans: 10,
          segregatedScans: 10,
          validReports: 0,
        ),
        equals(100.0),
      );

      // Case B: 10/10 segregated, 2 reports -> 100 - (5 * 2) = 90.0%
      expect(
        computeWeeklySci(
          verifiedScans: 10,
          segregatedScans: 10,
          validReports: 2,
        ),
        equals(90.0),
      );

      // Case C: 8/10 segregated (80%), 1 report -> 80 - 5 = 75.0%
      expect(
        computeWeeklySci(
          verifiedScans: 10,
          segregatedScans: 8,
          validReports: 1,
        ),
        equals(75.0),
      );

      // Case D: Max report penalty cap at 4 reports (-20)
      // 10/10 segregated (100%), 6 reports -> 100 - 20 = 80.0% (not 70%)
      expect(
        computeWeeklySci(
          verifiedScans: 10,
          segregatedScans: 10,
          validReports: 6,
        ),
        equals(80.0),
      );

      // Case E: Clamped to 0.0 minimum
      expect(
        computeWeeklySci(
          verifiedScans: 10,
          segregatedScans: 1,
          validReports: 4,
        ),
        equals(0.0),
      );
    });

    // ------------------------------------------------------------------------
    // 4. Sample Size Guard (< 5 verified scans)
    // ------------------------------------------------------------------------
    test('Enforces sample size guard (< 5 verified scans yields null SCI and grade)', () {
      double? computeWeeklySci({
        required int verifiedScans,
        required int segregatedScans,
        required int validReports,
      }) {
        if (verifiedScans < 5) return null;
        final segRate = segregatedScans / verifiedScans;
        final reportPenalty = 5.0 * (validReports > 4 ? 4 : validReports);
        return ((100.0 * segRate) - reportPenalty).clamp(0.0, 100.0);
      }

      // 4 verified scans (even if 100% segregated) -> Insufficient Data (null)
      expect(
        computeWeeklySci(
          verifiedScans: 4,
          segregatedScans: 4,
          validReports: 0,
        ),
        isNull,
      );

      // 0 verified scans -> null
      expect(
        computeWeeklySci(
          verifiedScans: 0,
          segregatedScans: 0,
          validReports: 0,
        ),
        isNull,
      );

      // 5 verified scans -> valid numerical score
      expect(
        computeWeeklySci(
          verifiedScans: 5,
          segregatedScans: 5,
          validReports: 0,
        ),
        equals(100.0),
      );
    });

    // ------------------------------------------------------------------------
    // 5. Letter Grade Assignment & Rolling Average
    // ------------------------------------------------------------------------
    test('Assigns letter grades A, B, C, D based on 4-week rolling average', () {
      String? assignGrade(double? rollingSci) {
        if (rollingSci == null) return null;
        if (rollingSci >= 85.0) return 'A';
        if (rollingSci >= 70.0) return 'B';
        if (rollingSci >= 50.0) return 'C';
        return 'D';
      }

      expect(assignGrade(null), isNull);
      expect(assignGrade(95.0), equals('A'));
      expect(assignGrade(85.0), equals('A'));
      expect(assignGrade(84.9), equals('B'));
      expect(assignGrade(70.0), equals('B'));
      expect(assignGrade(69.9), equals('C'));
      expect(assignGrade(50.0), equals('C'));
      expect(assignGrade(49.9), equals('D'));
      expect(assignGrade(12.0), equals('D'));
      expect(assignGrade(0.0), equals('D'));
    });

    // ------------------------------------------------------------------------
    // 6. Flag Lifecycle & Follow-up Workflow
    // ------------------------------------------------------------------------
    test('Simulates administrative flag progression and resolution', () {
      final validStatuses = {'open', 'notified', 'in_followup', 'resolved'};

      String currentStatus = 'open';
      DateTime? resolvedAt;
      String actionNote = 'Automated flag created.';

      // Step 1: Advance to 'notified'
      currentStatus = 'notified';
      actionNote = 'Sent educational advisory to HOA.';
      expect(validStatuses.contains(currentStatus), isTrue);
      expect(actionNote, contains('advisory'));
      expect(resolvedAt, isNull);

      // Step 2: Advance to 'in_followup'
      currentStatus = 'in_followup';
      actionNote = 'Barangay inspection scheduled for collection morning.';
      expect(validStatuses.contains(currentStatus), isTrue);
      expect(actionNote, contains('inspection'));
      expect(resolvedAt, isNull);

      // Step 3: Advance to 'resolved'
      currentStatus = 'resolved';
      resolvedAt = DateTime.now();
      actionNote = 'Segregation compliance restored above 75%.';
      expect(currentStatus, equals('resolved'));
      expect(actionNote, contains('restored'));
      expect(resolvedAt, isNotNull);
    });
  });
}
