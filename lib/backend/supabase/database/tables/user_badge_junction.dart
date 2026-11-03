import '../database.dart';

class UserBadgeJunctionTable extends SupabaseTable<UserBadgeJunctionRow> {
  @override
  String get tableName => 'user_badge_junction';

  @override
  UserBadgeJunctionRow createRow(Map<String, dynamic> data) =>
      UserBadgeJunctionRow(data);
}

class UserBadgeJunctionRow extends SupabaseDataRow {
  UserBadgeJunctionRow(super.data);

  @override
  SupabaseTable get table => UserBadgeJunctionTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get badgeId => getField<String>('badge_id')!;
  set badgeId(String value) => setField<String>('badge_id', value);

  DateTime get awardedAt =>
      getField<DateTime>('awarded_at') ?? DateTime.now();
  set awardedAt(DateTime value) => setField<DateTime>('awarded_at', value);

  DateTime? get seenAt => getField<DateTime>('seen_at');
  set seenAt(DateTime? value) => setField<DateTime>('seen_at', value);
}
