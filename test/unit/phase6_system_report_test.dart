import 'package:flutter_test/flutter_test.dart';

/// Test mock classes representing street and image records for Phase 6 system reporting
class MockStreetRecord {
  final int streetId;
  final String streetName;
  final String? lastUpdatedBy;
  final DateTime? lastUpdatedTime;
  final DateTime createdAt;

  MockStreetRecord({
    required this.streetId,
    required this.streetName,
    this.lastUpdatedBy,
    this.lastUpdatedTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime(2026, 1, 1);
}

class MockImageRecord {
  final int id;
  final String imgStreetNameRef;
  final String status;
  final String imgUploader;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MockImageRecord({
    required this.id,
    required this.imgStreetNameRef,
    required this.status,
    required this.imgUploader,
    this.updatedBy,
    required this.createdAt,
    this.updatedAt,
  });
}

class TestStreetReportSummary {
  final String streetName;
  final int? streetId;
  final int totalImages;
  final int nonVerifiedImages;
  final int verifiedImages;
  final int uploadsToday;
  final int uploadsLastHour;
  final String lastUpdatedBy;
  final DateTime? lastUpdatedTime;

  TestStreetReportSummary({
    required this.streetName,
    this.streetId,
    required this.totalImages,
    required this.nonVerifiedImages,
    required this.verifiedImages,
    required this.uploadsToday,
    required this.uploadsLastHour,
    required this.lastUpdatedBy,
    this.lastUpdatedTime,
  });
}

/// Pure calculation function mirroring _buildSummaries logic in PReportSystemWidget
List<TestStreetReportSummary> computeStreetSummaries({
  required List<MockStreetRecord> streets,
  required List<MockImageRecord> images,
  required DateTime referenceNow,
  String sortBy = 'Alphabetical',
}) {
  final startOfToday =
      DateTime(referenceNow.year, referenceNow.month, referenceNow.day);
  final oneHourAgo = referenceNow.subtract(const Duration(hours: 1));

  final Map<String, MockStreetRecord?> streetMap = {};
  for (final s in streets) {
    final trimmed = s.streetName.trim();
    if (trimmed.isNotEmpty) {
      streetMap[trimmed] = s;
    }
  }
  for (final img in images) {
    final name = img.imgStreetNameRef.trim();
    if (name.isNotEmpty &&
        !streetMap.keys.any((k) => k.toLowerCase() == name.toLowerCase())) {
      streetMap[name] = null;
    }
  }

  final List<TestStreetReportSummary> summaries = [];

  for (final entry in streetMap.entries) {
    final streetName = entry.key;
    final streetRow = entry.value;

    final streetImages = images
        .where((img) =>
            img.imgStreetNameRef.trim().toLowerCase() ==
            streetName.toLowerCase())
        .toList();

    final totalImages = streetImages.length;
    final verifiedImages =
        streetImages.where((img) => img.status == 'Verified').length;
    final nonVerifiedImages = totalImages - verifiedImages;

    final uploadsToday =
        streetImages.where((img) => img.createdAt.isAfter(startOfToday)).length;
    final uploadsLastHour =
        streetImages.where((img) => img.createdAt.isAfter(oneHourAgo)).length;

    streetImages.sort((a, b) {
      final dateA = a.updatedAt ?? a.createdAt;
      final dateB = b.updatedAt ?? b.createdAt;
      return dateB.compareTo(dateA);
    });

    String lastUpdatedBy = 'No updates yet';
    DateTime? lastUpdatedTime;

    if (streetImages.isNotEmpty) {
      final latestImg = streetImages.first;
      if (latestImg.updatedBy != null && latestImg.updatedBy!.isNotEmpty) {
        lastUpdatedBy = latestImg.updatedBy!;
      } else if (streetRow?.lastUpdatedBy != null &&
          streetRow!.lastUpdatedBy!.isNotEmpty) {
        lastUpdatedBy = streetRow.lastUpdatedBy!;
      } else if (latestImg.imgUploader.isNotEmpty) {
        lastUpdatedBy = latestImg.imgUploader;
      }
      lastUpdatedTime = latestImg.updatedAt ?? latestImg.createdAt;
    } else if (streetRow != null) {
      if (streetRow.lastUpdatedBy != null &&
          streetRow.lastUpdatedBy!.isNotEmpty) {
        lastUpdatedBy = streetRow.lastUpdatedBy!;
      }
      lastUpdatedTime = streetRow.lastUpdatedTime ?? streetRow.createdAt;
    }

    summaries.add(
      TestStreetReportSummary(
        streetName: streetName,
        streetId: streetRow?.streetId,
        totalImages: totalImages,
        nonVerifiedImages: nonVerifiedImages,
        verifiedImages: verifiedImages,
        uploadsToday: uploadsToday,
        uploadsLastHour: uploadsLastHour,
        lastUpdatedBy: lastUpdatedBy,
        lastUpdatedTime: lastUpdatedTime,
      ),
    );
  }

  if (sortBy == 'Pending First') {
    summaries
        .sort((a, b) => b.nonVerifiedImages.compareTo(a.nonVerifiedImages));
  } else if (sortBy == 'Most Uploads') {
    summaries.sort((a, b) => b.totalImages.compareTo(a.totalImages));
  } else {
    summaries.sort((a, b) => a.streetName.compareTo(b.streetName));
  }

  return summaries;
}

void main() {
  group('Phase 6: System Street Reports Hub & Dual-Page Architecture Tests', () {
    final fixedNow = DateTime(2026, 10, 16, 15, 30);

    final mockStreets = [
      MockStreetRecord(streetId: 1, streetName: 'Rizal St.'),
      MockStreetRecord(streetId: 2, streetName: 'Mabini St.'),
      MockStreetRecord(
        streetId: 3,
        streetName: 'Bonifacio St.',
        lastUpdatedBy: 'Admin Sofia',
        lastUpdatedTime: DateTime(2026, 10, 15, 10, 0),
      ),
    ];

    final mockImages = [
      // Rizal St. (1 verified, 1 non-verified, 2 total)
      MockImageRecord(
        id: 1,
        imgStreetNameRef: 'Rizal St.',
        status: 'Verified',
        imgUploader: 'User Juan',
        updatedBy: 'Admin Sofia',
        createdAt: DateTime(2026, 10, 16, 15, 0), // 30m ago (today & last hour)
        updatedAt: DateTime(2026, 10, 16, 15, 15),
      ),
      MockImageRecord(
        id: 2,
        imgStreetNameRef: 'rizal st.', // test case-insensitivity
        status: 'Categorized by Ai',
        imgUploader: 'User Maria',
        createdAt: DateTime(2026, 10, 16, 10, 0), // today, but >1 hour ago
      ),

      // Mabini St. (0 verified, 3 non-verified, 3 total)
      MockImageRecord(
        id: 3,
        imgStreetNameRef: 'Mabini St.',
        status: 'Categorized by Ai',
        imgUploader: 'User Pedro',
        createdAt: DateTime(2026, 10, 16, 14, 45), // 45m ago
      ),
      MockImageRecord(
        id: 4,
        imgStreetNameRef: 'Mabini St.',
        status: 'Categorized by Ai',
        imgUploader: 'User Pedro',
        createdAt: DateTime(2026, 10, 15, 12, 0), // yesterday
      ),
      MockImageRecord(
        id: 5,
        imgStreetNameRef: 'Mabini St.',
        status: 'Categorized by Ai',
        imgUploader: 'User Ana',
        createdAt: DateTime(2026, 10, 14, 8, 0), // two days ago
      ),

      // Bonifacio St. (0 images)
    ];

    test('Street report calculates total, verified, and non-verified image tallies accurately', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
      );

      final rizal = summaries.firstWhere((s) => s.streetName == 'Rizal St.');
      expect(rizal.totalImages, equals(2));
      expect(rizal.verifiedImages, equals(1));
      expect(rizal.nonVerifiedImages, equals(1));
      expect(rizal.totalImages, equals(rizal.verifiedImages + rizal.nonVerifiedImages));

      final mabini = summaries.firstWhere((s) => s.streetName == 'Mabini St.');
      expect(mabini.totalImages, equals(3));
      expect(mabini.verifiedImages, equals(0));
      expect(mabini.nonVerifiedImages, equals(3));

      final bonifacio = summaries.firstWhere((s) => s.streetName == 'Bonifacio St.');
      expect(bonifacio.totalImages, equals(0));
      expect(bonifacio.verifiedImages, equals(0));
      expect(bonifacio.nonVerifiedImages, equals(0));
    });

    test('Calculates uploads today and uploads within past hour accurately', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
      );

      final rizal = summaries.firstWhere((s) => s.streetName == 'Rizal St.');
      expect(rizal.uploadsToday, equals(2));
      expect(rizal.uploadsLastHour, equals(1));

      final mabini = summaries.firstWhere((s) => s.streetName == 'Mabini St.');
      expect(mabini.uploadsToday, equals(1));
      expect(mabini.uploadsLastHour, equals(1));

      final bonifacio = summaries.firstWhere((s) => s.streetName == 'Bonifacio St.');
      expect(bonifacio.uploadsToday, equals(0));
      expect(bonifacio.uploadsLastHour, equals(0));
    });

    test('Resolves lastUpdatedBy and relative timestamp fallback hierarchy properly', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
      );

      // Rizal St. has an image with updatedBy: 'Admin Sofia' and updatedAt
      final rizal = summaries.firstWhere((s) => s.streetName == 'Rizal St.');
      expect(rizal.lastUpdatedBy, equals('Admin Sofia'));
      expect(rizal.lastUpdatedTime, equals(DateTime(2026, 10, 16, 15, 15)));

      // Mabini St. has images without updatedBy, fallback to imgUploader of latest image
      final mabini = summaries.firstWhere((s) => s.streetName == 'Mabini St.');
      expect(mabini.lastUpdatedBy, equals('User Pedro'));
      expect(mabini.lastUpdatedTime, equals(DateTime(2026, 10, 16, 14, 45)));

      // Bonifacio St. has 0 images, fallback to StreetRow metadata
      final bonifacio = summaries.firstWhere((s) => s.streetName == 'Bonifacio St.');
      expect(bonifacio.lastUpdatedBy, equals('Admin Sofia'));
      expect(bonifacio.lastUpdatedTime, equals(DateTime(2026, 10, 15, 10, 0)));
    });

    test('Sorts correctly by Alphabetical (A-Z)', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
        sortBy: 'Alphabetical',
      );

      expect(summaries.map((s) => s.streetName).toList(), [
        'Bonifacio St.',
        'Mabini St.',
        'Rizal St.',
      ]);
    });

    test('Sorts correctly by Pending Moderation First', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
        sortBy: 'Pending First',
      );

      // Mabini (3 pending) -> Rizal (1 pending) -> Bonifacio (0 pending)
      expect(summaries.map((s) => s.streetName).toList(), [
        'Mabini St.',
        'Rizal St.',
        'Bonifacio St.',
      ]);
    });

    test('Sorts correctly by Most Uploads', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
        sortBy: 'Most Uploads',
      );

      // Mabini (3 total) -> Rizal (2 total) -> Bonifacio (0 total)
      expect(summaries.map((s) => s.streetName).toList(), [
        'Mabini St.',
        'Rizal St.',
        'Bonifacio St.',
      ]);
    });

    test('Filters summaries correctly with search query and dropdown selection', () {
      final summaries = computeStreetSummaries(
        streets: mockStreets,
        images: mockImages,
        referenceNow: fixedNow,
      );

      // Filter by dropdown = 'Rizal St.'
      final rizalFilter = summaries
          .where((s) => s.streetName.toLowerCase() == 'rizal st.')
          .toList();
      expect(rizalFilter.length, equals(1));
      expect(rizalFilter.first.streetName, equals('Rizal St.'));

      // Search query = 'bin' matches 'Mabini St.'
      final searchFilter = summaries
          .where((s) => s.streetName.toLowerCase().contains('bin'))
          .toList();
      expect(searchFilter.length, equals(1));
      expect(searchFilter.first.streetName, equals('Mabini St.'));
    });
  });
}
