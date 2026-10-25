import 'package:flutter_test/flutter_test.dart';

enum TestUserRole { guest, resident, crew, admin }

void main() {
  group('Phase 8: Guest Upload Persistence, Direct Camera Prompt & Resident Reporting Unit Tests', () {
    // ------------------------------------------------------------------------
    // 1. Role-Gated Camera Auto-Trigger Logic
    // ------------------------------------------------------------------------
    test('Camera auto-trigger is enabled for Resident and Guest, disabled for Admin and Crew', () {
      bool shouldAutoTriggerCamera(TestUserRole role) {
        switch (role) {
          case TestUserRole.resident:
          case TestUserRole.guest:
            return true;
          case TestUserRole.crew:
          case TestUserRole.admin:
            return false;
        }
      }

      expect(shouldAutoTriggerCamera(TestUserRole.resident), isTrue);
      expect(shouldAutoTriggerCamera(TestUserRole.guest), isTrue);
      expect(shouldAutoTriggerCamera(TestUserRole.crew), isFalse);
      expect(shouldAutoTriggerCamera(TestUserRole.admin), isFalse);
    });

    // ------------------------------------------------------------------------
    // 2. Guest Cloud Persistence & Points Guard Payload
    // ------------------------------------------------------------------------
    test('Guest upload payload properly formats Non-Verified, pending status and null uploader', () {
      Map<String, dynamic> buildGuestScanPayload({
        required String publicUrl,
        required bool isValid,
        required bool isRecyclable,
        required bool isSegregated,
        required bool isBiode,
        required bool isNonBiode,
      }) {
        final dominantTypes = <String>[];
        if (isRecyclable) dominantTypes.add('Recyclable');
        if (isBiode) dominantTypes.add('Biodegradable');
        if (isNonBiode) dominantTypes.add('Non-Biodegradable');
        final aiWasteTypeStr =
            dominantTypes.isNotEmpty ? dominantTypes.join(', ') : 'Unidentified';

        return {
          'img_uploader': null,
          'img_streetNameRef': 'Guest Upload',
          'img_reference_link': publicUrl,
          'status': 'Non-Verified',
          'verification_status': 'pending',
          'isSegregated': isSegregated,
          'category_recycling': isRecyclable,
          'category_biode': isBiode,
          'category_nonbiode': isNonBiode,
          'ai_classification': isSegregated ? 'Segregated' : 'Unsegregated',
          'ai_waste_type': aiWasteTypeStr,
          'ai_confidence_score': 90.00,
          'ai_raw_json': {
            'valid_waste_image': isValid,
            'recyclable': isRecyclable,
            'segregated': isSegregated,
            'biodegradable': isBiode,
            'non_biodegradable': isNonBiode,
            'uploader_role': 'Guest',
          },
        };
      }

      final payload = buildGuestScanPayload(
        publicUrl: 'https://example.supabase.co/storage/v1/object/public/Image_Bucket/Guest/guest_123.jpg',
        isValid: true,
        isRecyclable: true,
        isSegregated: true,
        isBiode: false,
        isNonBiode: true,
      );

      expect(payload['img_uploader'], isNull);
      expect(payload['status'], equals('Non-Verified'));
      expect(payload['verification_status'], equals('pending'));
      expect(payload['img_streetNameRef'], equals('Guest Upload'));
      expect(payload['ai_classification'], equals('Segregated'));
      expect(payload['ai_waste_type'], equals('Recyclable, Non-Biodegradable'));
      expect((payload['ai_raw_json'] as Map)['uploader_role'], equals('Guest'));
    });

    test('Guest scans never award gamification points because uploader row is null', () {
      bool canAwardPoints(String? uploaderId, Map<String, dynamic>? userSubtable) {
        return uploaderId != null && userSubtable != null;
      }

      expect(canAwardPoints(null, null), isFalse);
      expect(canAwardPoints('user-1', null), isFalse);
      expect(canAwardPoints(null, {'points': 10}), isFalse);
      expect(canAwardPoints('user-1', {'points': 10}), isTrue);
    });

    // ------------------------------------------------------------------------
    // 3. Uploader Name Display Fallback
    // ------------------------------------------------------------------------
    test('Uploader display resolves to Guest when uploader UID is null or sentinel', () {
      String resolveUploaderName({
        required String? uploaderUid,
        required String? userName,
        required String fallbackForUser,
      }) {
        if (userName != null && userName.trim().isNotEmpty) {
          return userName;
        }
        if (uploaderUid == null ||
            uploaderUid == '00000000-0000-0000-0000-000000000000' ||
            uploaderUid.isEmpty) {
          return 'Guest';
        }
        return fallbackForUser;
      }

      expect(
        resolveUploaderName(
          uploaderUid: null,
          userName: null,
          fallbackForUser: 'Resident',
        ),
        equals('Guest'),
      );

      expect(
        resolveUploaderName(
          uploaderUid: '00000000-0000-0000-0000-000000000000',
          userName: null,
          fallbackForUser: 'Resident',
        ),
        equals('Guest'),
      );

      expect(
        resolveUploaderName(
          uploaderUid: 'user-uuid-1234',
          userName: null,
          fallbackForUser: 'Resident',
        ),
        equals('Resident'),
      );

      expect(
        resolveUploaderName(
          uploaderUid: 'user-uuid-1234',
          userName: 'Juan Dela Cruz',
          fallbackForUser: 'Resident',
        ),
        equals('Juan Dela Cruz'),
      );
    });

    // ------------------------------------------------------------------------
    // 4. Resident Incident Reporting Payload & Validation
    // ------------------------------------------------------------------------
    test('Resident incident reporting payload contains required fields and validates non-empty inputs', () {
      bool validateReportInput({
        required String subject,
        required String description,
      }) {
        return subject.trim().isNotEmpty && description.trim().isNotEmpty;
      }

      expect(validateReportInput(subject: '', description: 'Something'), isFalse);
      expect(validateReportInput(subject: 'Overflow', description: ''), isFalse);
      expect(validateReportInput(subject: 'Illegal Dump', description: 'At corner lot'), isTrue);

      Map<String, dynamic> buildReportPayload({
        required String subject,
        required String description,
        required String street,
        required String reporterUid,
        String? imageUrl,
      }) {
        return {
          'report_subject': subject.trim(),
          'report_description': description.trim(),
          'report_streetNameRef': street,
          'reporter_userRef': reporterUid,
          'report_status': 'Pending',
          'report_image_link': imageUrl,
        };
      }

      final report = buildReportPayload(
        subject: 'Overflowing Bins',
        description: 'Public bins along Mabini Street are spilling onto sidewalk.',
        street: 'Mabini Street',
        reporterUid: 'resident-uid-789',
        imageUrl: 'https://example.supabase.co/storage/v1/object/public/Image_Bucket/Reports/report_999.jpg',
      );

      expect(report['report_subject'], equals('Overflowing Bins'));
      expect(report['report_description'], contains('spilling onto sidewalk'));
      expect(report['report_streetNameRef'], equals('Mabini Street'));
      expect(report['reporter_userRef'], equals('resident-uid-789'));
      expect(report['report_status'], equals('Pending'));
      expect(report['report_image_link'], isNotNull);
    });
  });
}
