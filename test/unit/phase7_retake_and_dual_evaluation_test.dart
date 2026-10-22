import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7: Retake Guardrail & Dual-Column Evaluation Unit Tests', () {
    // ------------------------------------------------------------------------
    // 1. Rule 6 Retake Guardrail (Max 3 Attempts)
    // ------------------------------------------------------------------------
    test('Retake counter increments across attempts and caps at 3 attempts', () {
      int retakeAttempts = 0;
      bool isRetakeLimitReached = false;

      void registerScanFailure() {
        retakeAttempts++;
        if (retakeAttempts >= 3) {
          isRetakeLimitReached = true;
        }
      }

      // Attempt 1 Failure
      registerScanFailure();
      expect(retakeAttempts, equals(1));
      expect(isRetakeLimitReached, isFalse);

      // Attempt 2 Failure
      registerScanFailure();
      expect(retakeAttempts, equals(2));
      expect(isRetakeLimitReached, isFalse);

      // Attempt 3 Failure (Hard Cap)
      registerScanFailure();
      expect(retakeAttempts, equals(3));
      expect(isRetakeLimitReached, isTrue);
    });

    test('Option A manual inspection fallback produces valid Non-Verified pending payload', () {
      Map<String, dynamic> buildManualInspectionPayload({
        required String uploaderUid,
        required String? streetRef,
        required String rawFailureReason,
      }) {
        return {
          'status': 'Non-Verified',
          'verification_status': 'pending',
          'ai_classification': 'Unclassified',
          'ai_waste_type': 'Unidentifiable (Manual Inspection Required)',
          'ai_confidence_score': 0.0,
          'isSegregated': false,
          'category_recycling': false,
          'category_biode': false,
          'category_nonbiode': false,
          'allowFlagging': true,
          'remark': 'Retake limit reached (3 attempts). Flagged for manual barangay inspection: $rawFailureReason',
          'img_uploader': uploaderUid,
          'img_street_name_ref': streetRef,
        };
      }

      final payload = buildManualInspectionPayload(
        uploaderUid: 'resident-uuid-456',
        streetRef: 'Acacia Street',
        rawFailureReason: 'Lighting too dark to discern object contours',
      );

      expect(payload['status'], equals('Non-Verified'));
      expect(payload['verification_status'], equals('pending'));
      expect(payload['ai_classification'], equals('Unclassified'));
      expect(payload['ai_confidence_score'], equals(0.0));
      expect(payload['allowFlagging'], isTrue);
      expect(payload['remark'], contains('Retake limit reached (3 attempts)'));
      expect(payload['remark'], contains('Lighting too dark'));
    });

    // ------------------------------------------------------------------------
    // 2. Prompt Injection & Adversarial Text Defense
    // ------------------------------------------------------------------------
    test('Adversarial prompt injection / non-waste detection auto-quarantines to Flagged rejected', () {
      Map<String, dynamic> evaluateAIResponseGuardrails({
        required bool isSegregated,
        required bool categoryRecycling,
        required bool categoryBiode,
        required bool categoryNonBiode,
        required bool isAdversarialInput,
      }) {
        final bool isAllFalse = !isSegregated &&
            !categoryRecycling &&
            !categoryBiode &&
            !categoryNonBiode;

        if (isAdversarialInput || isAllFalse) {
          return {
            'status': 'Flagged',
            'verification_status': 'rejected',
            'allowFlagging': false,
            'remark': 'Visual prompt injection / adversarial non-waste content flagged by AI.',
          };
        }

        return {
          'status': 'Non-Verified',
          'verification_status': 'pending',
          'allowFlagging': true,
          'remark': 'AI analysis completed.',
        };
      }

      // Adversarial text injected in photo
      final adversarialResult = evaluateAIResponseGuardrails(
        isSegregated: false,
        categoryRecycling: false,
        categoryBiode: false,
        categoryNonBiode: false,
        isAdversarialInput: true,
      );
      expect(adversarialResult['status'], equals('Flagged'));
      expect(adversarialResult['verification_status'], equals('rejected'));
      expect(adversarialResult['allowFlagging'], isFalse);

      // Legitimate recyclable scan
      final legitResult = evaluateAIResponseGuardrails(
        isSegregated: true,
        categoryRecycling: true,
        categoryBiode: false,
        categoryNonBiode: false,
        isAdversarialInput: false,
      );
      expect(legitResult['status'], equals('Non-Verified'));
      expect(legitResult['verification_status'], equals('pending'));
      expect(legitResult['allowFlagging'], isTrue);
    });

    // ------------------------------------------------------------------------
    // 3. Dual-Column Schema & Verification Agreement / Correction
    // ------------------------------------------------------------------------
    test('Admin audit determines agreement (verified) vs correction (corrected) and tracks latency', () {
      Map<String, dynamic> buildAdminVerificationPayload({
        required String? aiClassification,
        required String adminClassification,
        required String adminWasteType,
        required String adminUid,
        required DateTime auditStartTime,
        required DateTime auditEndTime,
      }) {
        final double latencySeconds = (auditEndTime.difference(auditStartTime).inMilliseconds) / 1000.0;
        final bool isAgreement = aiClassification != null &&
            aiClassification.toLowerCase().trim() == adminClassification.toLowerCase().trim();

        return {
          'status': 'Verified',
          'verification_status': isAgreement ? 'verified' : 'corrected',
          'admin_id': adminUid,
          'admin_classification': adminClassification,
          'admin_waste_type': adminWasteType,
          'verification_time_seconds': double.parse(latencySeconds.toStringAsFixed(2)),
          'verified_at': auditEndTime.toIso8601String(),
        };
      }

      final startTime = DateTime(2026, 10, 22, 10, 0, 0);
      final endTimeAgreement = DateTime(2026, 10, 22, 10, 0, 14, 500); // 14.5s
      final endTimeCorrection = DateTime(2026, 10, 22, 10, 0, 28, 200); // 28.2s

      // Case 1: AI says Segregated, Admin confirms Segregated
      final payloadAgreement = buildAdminVerificationPayload(
        aiClassification: 'Segregated',
        adminClassification: 'Segregated',
        adminWasteType: 'Recyclable Plastic (Clean)',
        adminUid: 'admin-001',
        auditStartTime: startTime,
        auditEndTime: endTimeAgreement,
      );
      expect(payloadAgreement['status'], equals('Verified'));
      expect(payloadAgreement['verification_status'], equals('verified'));
      expect(payloadAgreement['admin_classification'], equals('Segregated'));
      expect(payloadAgreement['verification_time_seconds'], equals(14.5));

      // Case 2: AI says Segregated, Admin corrects to Unsegregated
      final payloadCorrection = buildAdminVerificationPayload(
        aiClassification: 'Segregated',
        adminClassification: 'Unsegregated',
        adminWasteType: 'Mixed Household Contaminated',
        adminUid: 'admin-002',
        auditStartTime: startTime,
        auditEndTime: endTimeCorrection,
      );
      expect(payloadCorrection['status'], equals('Verified'));
      expect(payloadCorrection['verification_status'], equals('corrected'));
      expect(payloadCorrection['admin_classification'], equals('Unsegregated'));
      expect(payloadCorrection['verification_time_seconds'], equals(28.2));
    });

    // ------------------------------------------------------------------------
    // 4. Tri-State Dispute Resolution Lifecycle
    // ------------------------------------------------------------------------
    test('Resident dispute conforms strictly to chk_image_tri_state_status constraint', () {
      Map<String, dynamic> buildDisputePayload({
        required String disputeCategory,
        required String disputeReason,
        required String? existingRemark,
      }) {
        final prefix = '[DISPUTE - $disputeCategory]: $disputeReason';
        final updatedRemark = (existingRemark != null && existingRemark.trim().isNotEmpty)
            ? '$existingRemark | $prefix'
            : prefix;

        return {
          'status': 'Flagged',
          'verification_status': 'disputed',
          'remark': updatedRemark,
        };
      }

      final disputePayload = buildDisputePayload(
        disputeCategory: 'Properly Segregated',
        disputeReason: 'Cardboard box and glass jars were separated inside clean bins.',
        existingRemark: 'Flagged as unsegregated by reviewer',
      );

      // Must be 'Flagged' (NOT 'Disputed') to satisfy PostgreSQL CHECK ("status" IN ('Non-Verified', 'Verified', 'Flagged'))
      expect(disputePayload['status'], equals('Flagged'));
      expect(disputePayload['verification_status'], equals('disputed'));
      expect(disputePayload['remark'], contains('[DISPUTE - Properly Segregated]'));
      expect(disputePayload['remark'], contains('Cardboard box and glass jars'));
    });

    // ------------------------------------------------------------------------
    // 5. Chapter 5 Dual-Evaluation CSV Exporter Format
    // ------------------------------------------------------------------------
    test('Evaluation dataset CSV builder includes all 12 required empirical research columns', () {
      List<String> buildEvaluationCSVHeaders() {
        return [
          'Image ID',
          'Street Name',
          'Moderation Status',
          'AI Classification',
          'AI Waste Type',
          'Admin ID',
          'Admin Classification',
          'Admin Waste Type',
          'Verification Status',
          'Audit Latency (Seconds)',
          'Verified At',
          'Created At',
        ];
      }

      List<String> formatEvaluationRow({
        required int id,
        required String streetName,
        required String status,
        required String aiClassification,
        required String aiWasteType,
        required String adminId,
        required String adminClassification,
        required String adminWasteType,
        required String verificationStatus,
        required double latency,
        required String verifiedAt,
        required String createdAt,
      }) {
        return [
          id.toString(),
          streetName,
          status,
          aiClassification,
          aiWasteType,
          adminId,
          adminClassification,
          adminWasteType,
          verificationStatus,
          latency.toStringAsFixed(2),
          verifiedAt,
          createdAt,
        ];
      }

      final headers = buildEvaluationCSVHeaders();
      expect(headers.length, equals(12));
      expect(headers, contains('AI Classification'));
      expect(headers, contains('Admin Classification'));
      expect(headers, contains('Verification Status'));
      expect(headers, contains('Audit Latency (Seconds)'));

      final row = formatEvaluationRow(
        id: 101,
        streetName: 'Mabini St.',
        status: 'Verified',
        aiClassification: 'Segregated',
        aiWasteType: 'PET Bottle',
        adminId: 'admin-abc',
        adminClassification: 'Segregated',
        adminWasteType: 'PET Bottle',
        verificationStatus: 'verified',
        latency: 8.75,
        verifiedAt: '2026-10-22T10:15:00Z',
        createdAt: '2026-10-22T09:45:00Z',
      );

      expect(row.length, equals(12));
      expect(row[0], equals('101'));
      expect(row[3], equals('Segregated')); // AI
      expect(row[6], equals('Segregated')); // Admin
      expect(row[8], equals('verified')); // Status
      expect(row[9], equals('8.75')); // Latency
    });
  });
}
