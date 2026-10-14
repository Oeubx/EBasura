import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/flutter_flow/custom_functions.dart' as functions;
import 'package:a_e_basura/auth/role_util.dart';

void main() {
  group('formatWasteClassificationFeedback Tests', () {
    test('Correctly formats segregated recyclable waste', () {
      final feedback = functions.formatWasteClassificationFeedback(
        isSegregated: true,
        isRecyclable: true,
        isBiodegradable: false,
        isNonBiodegradable: false,
      );
      expect(
        feedback,
        equals('The waste seems segregated with combination of recyclable.'),
      );
    });

    test('Correctly formats not segregated combination of recyclable and non-biodegradable', () {
      final feedback = functions.formatWasteClassificationFeedback(
        isSegregated: false,
        isRecyclable: true,
        isBiodegradable: false,
        isNonBiodegradable: true,
      );
      expect(
        feedback,
        equals('The waste seems not segregated with combination of recyclable and non-biodegradable.'),
      );
    });

    test('Correctly formats all 3 categories combined', () {
      final feedback = functions.formatWasteClassificationFeedback(
        isSegregated: false,
        isRecyclable: true,
        isBiodegradable: true,
        isNonBiodegradable: true,
      );
      expect(
        feedback,
        equals('The waste seems not segregated with combination of recyclable, biodegradable, and non-biodegradable.'),
      );
    });

    test('Handles no categories selected', () {
      final feedback = functions.formatWasteClassificationFeedback(
        isSegregated: false,
        isRecyclable: false,
        isBiodegradable: false,
        isNonBiodegradable: false,
      );
      expect(
        feedback,
        equals('The waste seems not segregated with combination of unidentified waste.'),
      );
    });
  });

  group('formatWasteClassificationFromList Tests', () {
    test('Parses valid Gemini 5-attribute list correctly', () {
      final responseList = ['true', 'true', 'false', 'false', 'true'];
      final feedback = functions.formatWasteClassificationFromList(responseList);
      expect(
        feedback,
        equals('The waste seems not segregated with combination of recyclable and non-biodegradable.'),
      );
    });

    test('Handles invalid waste image response gracefully', () {
      final responseList = ['false', 'false', 'false', 'false', 'false'];
      final feedback = functions.formatWasteClassificationFromList(responseList);
      expect(
        feedback,
        equals('The uploaded image does not appear to contain valid identifiable waste.'),
      );
    });

    test('Handles short or empty response list safely', () {
      expect(
        functions.formatWasteClassificationFromList([]),
        equals('The waste could not be classified accurately.'),
      );
      expect(
        functions.formatWasteClassificationFromList(null),
        equals('The waste could not be classified accurately.'),
      );
    });
  });

  group('RoleService Tests', () {
    test('Detects Admin role case-insensitively', () {
      expect(RoleService.isAdmin('Admin'), isTrue);
      expect(RoleService.isAdmin('admin'), isTrue);
      expect(RoleService.isAdmin('ADMIN'), isTrue);
      expect(RoleService.isAdmin('User'), isFalse);
      expect(RoleService.isAdmin(null), isFalse);
    });

    test('Detects Resident role correctly', () {
      expect(RoleService.isResident('User'), isTrue);
      expect(RoleService.isResident('resident'), isTrue);
      expect(RoleService.isResident('Admin'), isFalse);
    });

    test('Parses roles to UserRole enum', () {
      expect(RoleService.parseRole('Admin'), equals(UserRole.admin));
      expect(RoleService.parseRole('Crew'), equals(UserRole.crew));
      expect(RoleService.parseRole('User'), equals(UserRole.resident));
      expect(RoleService.parseRole(null), equals(UserRole.guest));
      expect(RoleService.parseRole(''), equals(UserRole.guest));
    });
  });
}
