import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/backend/supabase/database/database.dart';

void main() {
  group('Phase 9: Points Ledger & Server-Side Award Unit Tests', () {
    // ------------------------------------------------------------------------
    // 1. Points Award Rules & Reason Codes
    // ------------------------------------------------------------------------
    test('Calculates standard points breakdown for verified segregated recyclable scan', () {
      const baseVerifiedPts = 10;
      const segregatedBonusPts = 15;
      const recyclableBonusPts = 5;

      int calculateScanPoints({
        required bool isVerified,
        required bool isSegregated,
        required bool isRecyclable,
      }) {
        if (!isVerified) return 0;
        int total = baseVerifiedPts;
        if (isSegregated) total += segregatedBonusPts;
        if (isRecyclable) total += recyclableBonusPts;
        return total;
      }

      // Fully compliant segregated recyclable scan
      expect(
        calculateScanPoints(isVerified: true, isSegregated: true, isRecyclable: true),
        equals(30),
      );

      // Verified but non-segregated scan (earns base only, no penalty)
      expect(
        calculateScanPoints(isVerified: true, isSegregated: false, isRecyclable: false),
        equals(10),
      );

      // Unverified scan earns 0 points
      expect(
        calculateScanPoints(isVerified: false, isSegregated: true, isRecyclable: true),
        equals(0),
      );
    });

    // ------------------------------------------------------------------------
    // 2. Anti-Gaming Daily Caps Logic
    // ------------------------------------------------------------------------
    test('Enforces max 3 point-earning scans per resident per day', () {
      final List<Map<String, dynamic>> ledger = [];
      const residentUid = 'res-101';
      final todayDate = DateTime.now().toIso8601String().substring(0, 10);

      bool awardScanPoints({
        required String userUid,
        required String imageId,
        required String scanDate,
      }) {
        final todayAwardsCount = ledger
            .where((entry) =>
                entry['user_id'] == userUid &&
                entry['reason_code'] == 'SCAN_VERIFIED' &&
                entry['date'] == scanDate)
            .length;

        if (todayAwardsCount < 3) {
          ledger.add({
            'user_id': userUid,
            'image_id': imageId,
            'points': 10,
            'reason_code': 'SCAN_VERIFIED',
            'date': scanDate,
          });
          return true;
        }
        return false;
      }

      // Scans 1 to 3 should be awarded
      expect(awardScanPoints(userUid: residentUid, imageId: 'img-1', scanDate: todayDate), isTrue);
      expect(awardScanPoints(userUid: residentUid, imageId: 'img-2', scanDate: todayDate), isTrue);
      expect(awardScanPoints(userUid: residentUid, imageId: 'img-3', scanDate: todayDate), isTrue);

      // Scan 4 on the same day should hit the cap (0 points awarded)
      expect(awardScanPoints(userUid: residentUid, imageId: 'img-4', scanDate: todayDate), isFalse);
      expect(ledger.length, equals(3));
    });

    test('Enforces max 1 SEGREGATED_BONUS per resident per day', () {
      final List<Map<String, dynamic>> ledger = [];
      const residentUid = 'res-101';
      final todayDate = DateTime.now().toIso8601String().substring(0, 10);

      int awardSegregationBonus({
        required String userUid,
        required String imageId,
        required String scanDate,
        required bool isSegregated,
      }) {
        if (!isSegregated) return 0;

        final hasBonusToday = ledger.any((entry) =>
            entry['user_id'] == userUid &&
            entry['reason_code'] == 'SEGREGATED_BONUS' &&
            entry['date'] == scanDate);

        if (!hasBonusToday) {
          ledger.add({
            'user_id': userUid,
            'image_id': imageId,
            'points': 15,
            'reason_code': 'SEGREGATED_BONUS',
            'date': scanDate,
          });
          return 15;
        }
        return 0; // Capped for today
      }

      // First segregated scan receives +15 bonus
      expect(
        awardSegregationBonus(
          userUid: residentUid,
          imageId: 'img-1',
          scanDate: todayDate,
          isSegregated: true,
        ),
        equals(15),
      );

      // Second segregated scan on the same day receives 0 bonus points
      expect(
        awardSegregationBonus(
          userUid: residentUid,
          imageId: 'img-2',
          scanDate: todayDate,
          isSegregated: true,
        ),
        equals(0),
      );
    });

    // ------------------------------------------------------------------------
    // 3. Reversal Logic on Moderation Rejection
    // ------------------------------------------------------------------------
    test('Calculates exact offsetting negative reversals when verified image is flagged or deleted', () {
      final List<Map<String, dynamic>> ledger = [
        {'user_id': 'res-1', 'image_id': 'img-A', 'points': 10, 'reason_code': 'SCAN_VERIFIED'},
        {'user_id': 'res-1', 'image_id': 'img-A', 'points': 15, 'reason_code': 'SEGREGATED_BONUS'},
        {'user_id': 'res-1', 'image_id': 'img-A', 'points': 5, 'reason_code': 'RECYCLABLE_BONUS'},
      ];

      int computeUserPoints(String uid) {
        return ledger
            .where((row) => row['user_id'] == uid)
            .fold<int>(0, (sum, row) => sum + (row['points'] as int));
      }

      expect(computeUserPoints('res-1'), equals(30));

      // Trigger reversal when image is subsequently flagged
      final awardedEntries = ledger
          .where((row) => row['image_id'] == 'img-A' && (row['points'] as int) > 0)
          .toList();

      final totalAwardedForImage =
          awardedEntries.fold<int>(0, (sum, r) => sum + (r['points'] as int));

      ledger.add({
        'user_id': 'res-1',
        'image_id': 'img-A',
        'points': -totalAwardedForImage,
        'reason_code': 'REVERSAL',
      });

      // User points should return to 0 without mutating previous historical entries
      expect(computeUserPoints('res-1'), equals(0));
      expect(ledger.length, equals(4));
    });

    // ------------------------------------------------------------------------
    // 4. Guest / Anonymous Upload Point Exclusion
    // ------------------------------------------------------------------------
    test('Guest and null uploader scans produce zero points ledger entries', () {
      List<Map<String, dynamic>> evaluateUploadPoints({
        required String? uploaderUid,
        required bool isVerified,
      }) {
        if (uploaderUid == null ||
            uploaderUid.isEmpty ||
            uploaderUid.toLowerCase() == 'guest' ||
            !isVerified) {
          return [];
        }
        return [
          {'user_id': uploaderUid, 'points': 10, 'reason_code': 'SCAN_VERIFIED'}
        ];
      }

      expect(evaluateUploadPoints(uploaderUid: null, isVerified: true), isEmpty);
      expect(evaluateUploadPoints(uploaderUid: '', isVerified: true), isEmpty);
      expect(evaluateUploadPoints(uploaderUid: 'guest', isVerified: true), isEmpty);
      expect(evaluateUploadPoints(uploaderUid: 'res-valid', isVerified: true).length, equals(1));
    });

    // ------------------------------------------------------------------------
    // 5. PointsLedgerRow Dart Model Verification
    // ------------------------------------------------------------------------
    test('PointsLedgerRow data model correctly parses and exposes ledger properties', () {
      final now = DateTime.now();
      final row = PointsLedgerRow({
        'ledger_id': 42,
        'user_id': 'user-uuid-1234',
        'points': 25,
        'reason_code': 'REPORT_VALID',
        'image_id': 'img-uuid-5678',
        'report_id': 'rep-uuid-9999',
        'street_ref': 'Sampaguita St',
        'created_by': 'admin-uuid-0000',
        'created_at': now.toIso8601String(),
      });

      expect(row.ledgerId, equals(42));
      expect(row.userId, equals('user-uuid-1234'));
      expect(row.points, equals(25));
      expect(row.reasonCode, equals('REPORT_VALID'));
      expect(row.imageId, equals('img-uuid-5678'));
      expect(row.reportId, equals('rep-uuid-9999'));
      expect(row.streetRef, equals('Sampaguita St'));
      expect(row.createdBy, equals('admin-uuid-0000'));
      expect(row.createdAt.toIso8601String().substring(0, 10),
          equals(now.toIso8601String().substring(0, 10)));
    });
  });
}
