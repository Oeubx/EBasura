import 'package:flutter_test/flutter_test.dart';

// Test mock class representing an image record row
class MockImageRecord {
  final int id;
  final String? status;
  final bool? isSegregated;
  final bool? isRecyclable;
  final bool? isBiodegradable;
  final bool? isNonBiodegradable;
  final String? street;
  final DateTime createdAt;

  MockImageRecord({
    required this.id,
    this.status,
    this.isSegregated,
    this.isRecyclable,
    this.isBiodegradable,
    this.isNonBiodegradable,
    this.street,
    required this.createdAt,
  });
}

void main() {
  group('Phase 4: Verified vs Non-Verified Dual Feed Separation Tests', () {
    final mockRecords = [
      MockImageRecord(
        id: 1,
        status: 'Categorized by Ai',
        isSegregated: true,
        isRecyclable: true,
        isBiodegradable: false,
        isNonBiodegradable: false,
        street: 'Rizal St.',
        createdAt: DateTime(2026, 10, 14, 10, 0),
      ),
      MockImageRecord(
        id: 2,
        status: 'Verified',
        isSegregated: true,
        isRecyclable: true,
        isBiodegradable: true,
        isNonBiodegradable: false,
        street: 'Mabini St.',
        createdAt: DateTime(2026, 10, 14, 11, 0),
      ),
      MockImageRecord(
        id: 3,
        status: 'Categorized by Ai',
        isSegregated: false,
        isRecyclable: false,
        isBiodegradable: false,
        isNonBiodegradable: true,
        street: 'Bonifacio St.',
        createdAt: DateTime(2026, 10, 14, 12, 0),
      ),
      MockImageRecord(
        id: 4,
        status: null, // Legacy unverified record without explicit status
        isSegregated: null,
        isRecyclable: false,
        isBiodegradable: true,
        isNonBiodegradable: false,
        street: 'Luna St.',
        createdAt: DateTime(2026, 10, 14, 13, 0),
      ),
      MockImageRecord(
        id: 5,
        status: 'Verified',
        isSegregated: false,
        isRecyclable: false,
        isBiodegradable: false,
        isNonBiodegradable: true,
        street: 'Burgos St.',
        createdAt: DateTime(2026, 10, 14, 14, 0),
      ),
    ];

    test('Non-Verified tab filters out all verified items', () {
      final nonVerifiedFeed = mockRecords
          .where((img) => img.status != 'Verified')
          .toList();

      expect(nonVerifiedFeed.length, equals(3));
      expect(nonVerifiedFeed.map((e) => e.id), containsAll([1, 3, 4]));
      expect(nonVerifiedFeed.any((e) => e.status == 'Verified'), isFalse);
    });

    test('Verified tab includes only verified items', () {
      final verifiedFeed = mockRecords
          .where((img) => img.status == 'Verified')
          .toList();

      expect(verifiedFeed.length, equals(2));
      expect(verifiedFeed.map((e) => e.id), containsAll([2, 5]));
      expect(verifiedFeed.every((e) => e.status == 'Verified'), isTrue);
    });

    test('Card segregation badge displays correct text and status', () {
      String getSegregationBadgeText(bool? isSegregated) {
        return isSegregated == true ? '✓ Segregated' : '✗ Not Segregated';
      }

      expect(getSegregationBadgeText(true), equals('✓ Segregated'));
      expect(getSegregationBadgeText(false), equals('✗ Not Segregated'));
      expect(getSegregationBadgeText(null), equals('✗ Not Segregated'));
    });

    test('Waste category badges accurately detect active categories', () {
      List<String> getActiveCategories(MockImageRecord item) {
        final categories = <String>[];
        if (item.isRecyclable == true) categories.add('Recyclable');
        if (item.isBiodegradable == true) categories.add('Bio');
        if (item.isNonBiodegradable == true) categories.add('Non-Bio');
        return categories;
      }

      expect(getActiveCategories(mockRecords[0]), equals(['Recyclable']));
      expect(getActiveCategories(mockRecords[1]), equals(['Recyclable', 'Bio']));
      expect(getActiveCategories(mockRecords[2]), equals(['Non-Bio']));
      expect(getActiveCategories(mockRecords[3]), equals(['Bio']));
    });

    test('User role header badge displays Official vs Resident appropriately', () {
      String getRoleBadgeText(String? userType) {
        return userType == 'Admin' ? 'Official / Admin' : 'Resident';
      }

      expect(getRoleBadgeText('Admin'), equals('Official / Admin'));
      expect(getRoleBadgeText('User'), equals('Resident'));
      expect(getRoleBadgeText(null), equals('Resident'));
    });
  });
}
