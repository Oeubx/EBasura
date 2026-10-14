import 'package:flutter_test/flutter_test.dart';
import 'package:a_e_basura/auth/role_util.dart';

void main() {
  group('Phase 5: Admin Verification & Moderation Unit Tests', () {
    test('Admin verification payload generates status: "Verified" and remarks fallback', () {
      Map<String, dynamic> buildVerificationPayload({
        required bool isSegregated,
        required bool categoryRecycling,
        required bool categoryBiode,
        required bool categoryNonBiode,
        required String? adminRemarks,
        required String adminUid,
      }) {
        final finalRemark = (adminRemarks != null && adminRemarks.trim().isNotEmpty)
            ? adminRemarks.trim()
            : 'Verified by official';

        return {
          'status': 'Verified',
          'remark': finalRemark,
          'updated_by': adminUid,
          'allowFlagging': false,
          'isSegregated': isSegregated,
          'category_recycling': categoryRecycling,
          'category_biode': categoryBiode,
          'category_nonbiode': categoryNonBiode,
        };
      }

      // Case 1: Custom remark
      final payload1 = buildVerificationPayload(
        isSegregated: true,
        categoryRecycling: true,
        categoryBiode: false,
        categoryNonBiode: false,
        adminRemarks: 'Properly washed and separated PET bottles',
        adminUid: 'admin-123',
      );
      expect(payload1['status'], equals('Verified'));
      expect(payload1['remark'], equals('Properly washed and separated PET bottles'));
      expect(payload1['isSegregated'], isTrue);
      expect(payload1['category_recycling'], isTrue);
      expect(payload1['category_biode'], isFalse);

      // Case 2: Fallback remark when empty
      final payload2 = buildVerificationPayload(
        isSegregated: false,
        categoryRecycling: false,
        categoryBiode: true,
        categoryNonBiode: true,
        adminRemarks: '',
        adminUid: 'admin-123',
      );
      expect(payload2['status'], equals('Verified'));
      expect(payload2['remark'], equals('Verified by official'));
      expect(payload2['isSegregated'], isFalse);
    });

    test('Gamification point calculation awards tiered points based on active categories', () {
      int calculateEarnedPoints({
        required bool isSegregated,
        required bool recycling,
        required bool biode,
        required bool nonbiode,
      }) {
        if (!isSegregated) return 0;

        int activeCategories = 0;
        if (recycling) activeCategories++;
        if (biode) activeCategories++;
        if (nonbiode) activeCategories++;

        if (activeCategories >= 3) {
          return 100;
        } else if (activeCategories == 2) {
          return 50;
        } else if (activeCategories == 1) {
          return 25;
        }
        return 0;
      }

      // 3 categories: 100 points
      expect(calculateEarnedPoints(isSegregated: true, recycling: true, biode: true, nonbiode: true), equals(100));
      // 2 categories: 50 points
      expect(calculateEarnedPoints(isSegregated: true, recycling: true, biode: true, nonbiode: false), equals(50));
      expect(calculateEarnedPoints(isSegregated: true, recycling: false, biode: true, nonbiode: true), equals(50));
      // 1 category: 25 points
      expect(calculateEarnedPoints(isSegregated: true, recycling: true, biode: false, nonbiode: false), equals(25));
      expect(calculateEarnedPoints(isSegregated: true, recycling: false, biode: true, nonbiode: false), equals(25));
      // Unsegregated: 0 points
      expect(calculateEarnedPoints(isSegregated: false, recycling: true, biode: true, nonbiode: true), equals(0));
    });

    test('Notification alert triggers for resident when waste is not segregated', () {
      Map<String, dynamic> buildGamificationUpdate({
        required bool isSegregated,
        required int currentPoints,
        required int earnedPoints,
      }) {
        if (isSegregated) {
          return {
            'user_points': currentPoints + earnedPoints,
            'notification': false,
          };
        } else {
          return {
            'notification': true,
          };
        }
      }

      final segregatedUpdate = buildGamificationUpdate(
        isSegregated: true,
        currentPoints: 150,
        earnedPoints: 50,
      );
      expect(segregatedUpdate['user_points'], equals(200));
      expect(segregatedUpdate['notification'], isFalse);

      final unsegregatedUpdate = buildGamificationUpdate(
        isSegregated: false,
        currentPoints: 150,
        earnedPoints: 0,
      );
      expect(unsegregatedUpdate.containsKey('user_points'), isFalse);
      expect(unsegregatedUpdate['notification'], isTrue);
    });

    test('Role-based verifier action controls differentiate admin vs resident', () {
      bool canAdminVerify(String? userType) => RoleService.isAdmin(userType);
      bool canResidentDeleteOwnUnverified({
        required String? userType,
        required String imageUploaderUid,
        required String currentUserUid,
        required String status,
      }) {
        if (RoleService.isAdmin(userType)) return true;
        return imageUploaderUid == currentUserUid && status != 'Verified';
      }

      // Admin user
      expect(canAdminVerify('Admin'), isTrue);
      expect(canResidentDeleteOwnUnverified(
        userType: 'Admin',
        imageUploaderUid: 'other-user',
        currentUserUid: 'admin-uid',
        status: 'Verified',
      ), isTrue);

      // Resident user
      expect(canAdminVerify('User'), isFalse);
      expect(canAdminVerify(null), isFalse);

      // Resident can delete own unverified waste
      expect(canResidentDeleteOwnUnverified(
        userType: 'User',
        imageUploaderUid: 'user-123',
        currentUserUid: 'user-123',
        status: 'Categorized by Ai',
      ), isTrue);

      // Resident cannot delete verified waste or other resident waste
      expect(canResidentDeleteOwnUnverified(
        userType: 'User',
        imageUploaderUid: 'user-123',
        currentUserUid: 'user-123',
        status: 'Verified',
      ), isFalse);
      expect(canResidentDeleteOwnUnverified(
        userType: 'User',
        imageUploaderUid: 'other-user',
        currentUserUid: 'user-123',
        status: 'Categorized by Ai',
      ), isFalse);
    });
  });
}
