import '../database.dart';

class UserSubtableTable extends SupabaseTable<UserSubtableRow> {
  @override
  String get tableName => 'User Subtable';

  @override
  UserSubtableRow createRow(Map<String, dynamic> data) => UserSubtableRow(data);
}

class UserSubtableRow extends SupabaseDataRow {
  UserSubtableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserSubtableTable();

  String get userIdRef => getField<String>('user_idRef')!;
  set userIdRef(String value) => setField<String>('user_idRef', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get badgeIdRef => getField<String>('badge_idRef');
  set badgeIdRef(String? value) => setField<String>('badge_idRef', value);

  String? get feedback => getField<String>('feedback');
  set feedback(String? value) => setField<String>('feedback', value);

  int? get userPoints => getField<int>('user_points');
  set userPoints(int? value) => setField<int>('user_points', value);

  bool? get notification => getField<bool>('notification');
  set notification(bool? value) => setField<bool>('notification', value);

  int? get currentStreak => getField<int>('current_streak');
  set currentStreak(int? value) => setField<int>('current_streak', value);

  int? get bestStreak => getField<int>('best_streak');
  set bestStreak(int? value) => setField<int>('best_streak', value);

  DateTime? get streakUpdatedWeek => getField<DateTime>('streak_updated_week');
  set streakUpdatedWeek(DateTime? value) =>
      setField<DateTime>('streak_updated_week', value);

  bool? get freezeAvailable => getField<bool>('freeze_available');
  set freezeAvailable(bool? value) =>
      setField<bool>('freeze_available', value);

  String? get freezeUsedMonth => getField<String>('freeze_used_month');
  set freezeUsedMonth(String? value) =>
      setField<String>('freeze_used_month', value);

  int? get spendablePoints => getField<int>('spendable_points');
  set spendablePoints(int? value) => setField<int>('spendable_points', value);

  String? get leaderboardDisplay => getField<String>('leaderboard_display');
  set leaderboardDisplay(String? value) =>
      setField<String>('leaderboard_display', value);
}
