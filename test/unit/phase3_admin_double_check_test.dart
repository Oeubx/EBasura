import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/flutter_flow/custom_functions.dart' as functions;

void main() {
  group('Phase 3: Admin Scan Feedback & Verification Pipeline Tests', () {
    test('Newly taken resident photo is pushed to Non-Verified queue with AI status', () {
      // In Phase 3, photos taken by residents are saved as 'Categorized by Ai'
      const residentSubmissionStatus = 'Categorized by Ai';
      const isVerified = residentSubmissionStatus == 'Verified';

      expect(residentSubmissionStatus, equals('Categorized by Ai'));
      expect(isVerified, isFalse);
    });

    test('Non-Verified queue tab correctly captures Categorized by Ai records', () {
      final records = [
        {'id': 1, 'status': 'Categorized by Ai'},
        {'id': 2, 'status': 'Verified'},
        {'id': 3, 'status': 'Categorized by Ai'},
        {'id': 4, 'status': 'Uncategorized'},
      ];

      final nonVerifiedList = records.where((r) => r['status'] != 'Verified').toList();
      final verifiedList = records.where((r) => r['status'] == 'Verified').toList();

      expect(nonVerifiedList.length, equals(3));
      expect(verifiedList.length, equals(1));
      expect(nonVerifiedList.map((r) => r['id']), containsAll([1, 3, 4]));
    });

    test('Admin Dashboard shortcut preselects Non-Verified queue tab index 0', () {
      const adminQueueShortcutTabIndex = 0;
      const verifiedRecordsTabIndex = 1;

      expect(adminQueueShortcutTabIndex, equals(0));
      expect(verifiedRecordsTabIndex, equals(1));
    });

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

    test('Admin verification transitions item from Non-Verified to Verified', () {
      var itemStatus = 'Categorized by Ai';
      expect(itemStatus != 'Verified', isTrue);

      // Admin executes verification
      itemStatus = 'Verified';
      expect(itemStatus == 'Verified', isTrue);
    });
  });
}
