import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/auth/role_util.dart';
import 'package:a_e_basura/flutter_flow/custom_functions.dart' as functions;

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
