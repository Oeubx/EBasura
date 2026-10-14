import '/backend/supabase/supabase.dart';
import 'base_auth_user_provider.dart';

/// User roles in the EBasura ecosystem.
enum UserRole {
  admin,
  resident,
  crew,
  guest,
}

/// Helper and RBAC utility to determine and verify user roles.
class RoleService {
  /// Parses a string representation of a user role.
  static UserRole parseRole(String? userType) {
    if (userType == null || userType.trim().isEmpty) {
      return UserRole.guest;
    }
    switch (userType.trim().toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'crew':
        return UserRole.crew;
      case 'user':
      case 'resident':
      default:
        return UserRole.resident;
    }
  }

  /// Returns `true` if [userType] represents an Administrator or Barangay Official.
  static bool isAdmin(String? userType) =>
      userType != null && userType.trim().toLowerCase() == 'admin';

  /// Returns `true` if [userType] represents a Community Resident.
  static bool isResident(String? userType) => !isAdmin(userType);

  /// Returns `true` if [userType] represents Collection Crew.
  static bool isCrew(String? userType) =>
      userType != null && userType.trim().toLowerCase() == 'crew';

  /// Fetches the authenticated user's current role from the Supabase `User` table.
  static Future<UserRole> fetchCurrentUserRole() async {
    final uid = currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      return UserRole.guest;
    }
    try {
      final rows = await UserTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_id', uid),
      );
      if (rows.isNotEmpty) {
        return parseRole(rows.first.userType);
      }
    } catch (_) {
      // Fall back safely to resident role on network or query failure
    }
    return UserRole.resident;
  }
}
