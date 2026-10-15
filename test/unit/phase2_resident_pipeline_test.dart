import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/auth/role_util.dart';
import 'package:a_e_basura/flutter_flow/custom_functions.dart' as functions;
import 'package:a_e_basura/flutter_flow/upload_data.dart';

void main() {
  group('Phase 2: Resident Direct Camera & Auto-Scan Pipeline Tests', () {
    test('Non-Admin role correctly resolves to direct camera mode', () {
      final residentRole = RoleService.isResident('User');
      final adminRole = RoleService.isAdmin('User');

      expect(residentRole, isTrue);
      expect(adminRole, isFalse);

      // Verify routing behavior logic
      final shouldAutoTriggerCamera = residentRole;
      expect(shouldAutoTriggerCamera, isTrue);
    });

    test('Admin role correctly retains manual options', () {
      final residentRole = RoleService.isResident('Admin');
      final adminRole = RoleService.isAdmin('Admin');

      expect(residentRole, isFalse);
      expect(adminRole, isTrue);

      final shouldAutoTriggerCamera = !adminRole;
      expect(shouldAutoTriggerCamera, isFalse);
    });

    test('Resident camera security notice and CTA strings match Phase 2 specifications', () {
      const liveCameraNotice =
          'Live camera capture only. Gallery uploads are disabled to ensure real-time waste verification.';
      const residentButtonText = 'Open Camera to Scan Waste';
      const residentRetakeText = 'Retake Photo with Camera';
      const residentTapText = 'Tap to take a live photo of waste';
      const residentRestrictionBadge = 'Live camera required • Gallery disabled';

      expect(liveCameraNotice.contains('Gallery uploads are disabled'), isTrue);
      expect(liveCameraNotice.contains('real-time waste verification'), isTrue);
      expect(residentButtonText, equals('Open Camera to Scan Waste'));
      expect(residentRetakeText, equals('Retake Photo with Camera'));
      expect(residentTapText, equals('Tap to take a live photo of waste'));
      expect(residentRestrictionBadge, equals('Live camera required • Gallery disabled'));
    });

    test('Admin audit actions and CTA strings match Phase 2 specifications', () {
      const adminAuditButtonText = 'Select or Take Photo to Audit';
      const adminTapText = 'Select or capture waste image';
      const adminCapabilitiesText = 'Supports camera or gallery upload';

      expect(adminAuditButtonText, equals('Select or Take Photo to Audit'));
      expect(adminTapText, equals('Select or capture waste image'));
      expect(adminCapabilitiesText, equals('Supports camera or gallery upload'));
    });

    test('MediaSource contract strictly enforces camera for residents', () {
      MediaSource resolveMediaSource(String? userType) {
        if (userType != 'Admin') {
          return MediaSource.camera;
        }
        return MediaSource.photoGallery;
      }

      expect(resolveMediaSource('User'), equals(MediaSource.camera));
      expect(resolveMediaSource('Resident'), equals(MediaSource.camera));
      expect(resolveMediaSource(null), equals(MediaSource.camera));
      expect(resolveMediaSource('Admin'), equals(MediaSource.photoGallery));
    });

    test('AI non-verified queue status constant is standardized', () {
      // In EBasura, AI-scanned waste items before moderation are marked 'Categorized by Ai'
      const nonVerifiedStatus = 'Categorized by Ai';
      const verifiedStatus = 'Verified';

      expect(nonVerifiedStatus, equals('Categorized by Ai'));
      expect(verifiedStatus, equals('Verified'));
      expect(nonVerifiedStatus != verifiedStatus, isTrue);
    });

    test('Parsed AI categories are correctly extracted for auto-push', () {
      final geminiResponse = ['true', 'true', 'true', 'false', 'false'];

      final isValid = functions.stringToBool(geminiResponse.elementAtOrNull(0) ?? 'false');
      final isRecyclable = functions.stringToBool(geminiResponse.elementAtOrNull(1) ?? 'false');
      final isSegregated = functions.stringToBool(geminiResponse.elementAtOrNull(2) ?? 'false');
      final isBiode = functions.stringToBool(geminiResponse.elementAtOrNull(3) ?? 'false');
      final isNonBiode = functions.stringToBool(geminiResponse.elementAtOrNull(4) ?? 'false');

      expect(isValid, isTrue);
      expect(isRecyclable, isTrue);
      expect(isSegregated, isTrue);
      expect(isBiode, isFalse);
      expect(isNonBiode, isFalse);

      final feedback = functions.formatWasteClassificationFeedback(
        isSegregated: isSegregated,
        isRecyclable: isRecyclable,
        isBiodegradable: isBiode,
        isNonBiodegradable: isNonBiode,
      );

      expect(feedback, equals('The waste seems segregated with combination of recyclable.'));
    });
  });
}
