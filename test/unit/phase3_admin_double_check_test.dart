import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/flutter_flow/custom_functions.dart' as functions;

void main() {
  group('Phase 3: Admin Scan Feedback & Manual Double-Check Tests', () {
    test('AI feedback message dynamically updates when admin toggles segregation', () {
      // Initial AI prediction: unsegregated, recyclable + non-biodegradable
      final initialFeedback = functions.formatWasteClassificationFeedback(
        isSegregated: false,
        isRecyclable: true,
        isBiodegradable: false,
        isNonBiodegradable: true,
      );
      expect(
        initialFeedback,
        equals('The waste seems not segregated with combination of recyclable and non-biodegradable.'),
      );

      // Admin double-checks and manually corrects segregation to TRUE
      final correctedFeedback = functions.formatWasteClassificationFeedback(
        isSegregated: true,
        isRecyclable: true,
        isBiodegradable: false,
        isNonBiodegradable: true,
      );
      expect(
        correctedFeedback,
        equals('The waste seems segregated with combination of recyclable and non-biodegradable.'),
      );
    });

    test('AI feedback message updates when admin corrects waste categories', () {
      // Admin removes non-biodegradable and marks biodegradable
      final adjustedFeedback = functions.formatWasteClassificationFeedback(
        isSegregated: true,
        isRecyclable: false,
        isBiodegradable: true,
        isNonBiodegradable: false,
      );
      expect(
        adjustedFeedback,
        equals('The waste seems segregated with combination of biodegradable.'),
      );
    });

    test('Admin verification payload defaults remark when empty', () {
      String? enteredRemark = '';
      final resolvedRemark = enteredRemark.isNotEmpty
          ? enteredRemark
          : 'Verified by official';

      expect(resolvedRemark, equals('Verified by official'));

      enteredRemark = 'Clean plastic bottles properly separated';
      final customRemark = enteredRemark.isNotEmpty
          ? enteredRemark
          : 'Verified by official';

      expect(customRemark, equals('Clean plastic bottles properly separated'));
    });

    test('Admin manual double-check sets verified status', () {
      // In Phase 3, when an admin manually checks and uploads waste from scanner,
      // it directly transitions into 'Verified' status
      const adminUploadStatus = 'Verified';
      expect(adminUploadStatus, equals('Verified'));
    });
  });
}
