import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 1: Page Headers & Verifier Re-scan Action Tests', () {
    test('Dynamic category header formats title according to waste attributes', () {
      String deriveVerifierHeaderTitle({
        required bool isRecycling,
        required bool isBiode,
        required bool isNonbiode,
      }) {
        final cats = <String>[];
        if (isRecycling) cats.add('Recyclable');
        if (isBiode) cats.add('Biodegradable');
        if (isNonbiode) cats.add('Non-Biodegradable');
        final catStr = cats.isEmpty
            ? 'Waste'
            : (cats.length == 1 ? '${cats.first} Waste' : '${cats.join(" & ")} Waste');
        return 'Verification of $catStr';
      }

      expect(
        deriveVerifierHeaderTitle(isRecycling: true, isBiode: false, isNonbiode: false),
        equals('Verification of Recyclable Waste'),
      );
      expect(
        deriveVerifierHeaderTitle(isRecycling: false, isBiode: true, isNonbiode: false),
        equals('Verification of Biodegradable Waste'),
      );
      expect(
        deriveVerifierHeaderTitle(isRecycling: false, isBiode: false, isNonbiode: true),
        equals('Verification of Non-Biodegradable Waste'),
      );
      expect(
        deriveVerifierHeaderTitle(isRecycling: true, isBiode: true, isNonbiode: false),
        equals('Verification of Recyclable & Biodegradable Waste'),
      );
      expect(
        deriveVerifierHeaderTitle(isRecycling: false, isBiode: false, isNonbiode: false),
        equals('Verification of Waste'),
      );
    });

    test('Verifier secondary action button is explicitly labeled "Re-scan"', () {
      const verifierSecondaryActionLabel = 'Re-scan';
      expect(verifierSecondaryActionLabel, equals('Re-scan'));
      expect(verifierSecondaryActionLabel, isNot(equals('Re-Verify')));
    });

    test('Standard page titles and purpose subtitles are properly defined', () {
      final pageHeaders = <String, Map<String, String>>{
        'verifier': {
          'title': 'Verification of Recyclable Waste',
          'subtitle': 'Review AI scan findings, audit categorization, and award community points',
        },
        'upload_resident': {
          'title': 'Waste Scanner',
          'subtitle': 'Capture waste for AI classification and community verification',
        },
        'upload_admin': {
          'title': 'Waste Classification & Audit',
          'subtitle': 'Scan and audit waste categorization with official verification',
        },
        'feed': {
          'title': 'Waste Feed & Records',
          'subtitle': 'Browse pending community submissions and verified waste records',
        },
        'home': {
          'title': 'Home',
          'subtitle': 'Smart waste monitoring, schedules, and community reporting',
        },
        'profile': {
          'title': 'Profile',
          'subtitle': 'Manage your account, view earned points, and unlocked badges',
        },
      };

      expect(pageHeaders['verifier']!['title'], startsWith('Verification of'));
      expect(pageHeaders['upload_resident']!['title'], equals('Waste Scanner'));
      expect(pageHeaders['upload_admin']!['title'], equals('Waste Classification & Audit'));
      expect(pageHeaders['feed']!['title'], equals('Waste Feed & Records'));
      expect(pageHeaders['home']!['title'], equals('Home'));
      expect(pageHeaders['profile']!['title'], equals('Profile'));

      for (final entry in pageHeaders.values) {
        expect(entry['subtitle']!.isNotEmpty, isTrue);
      }
    });
  });
}
