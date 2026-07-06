import '../database.dart';

class BadgeTable extends SupabaseTable<BadgeRow> {
  @override
  String get tableName => 'Badge';

  @override
  BadgeRow createRow(Map<String, dynamic> data) => BadgeRow(data);
}

class BadgeRow extends SupabaseDataRow {
  BadgeRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BadgeTable();

  String? get badgeId => getField<String>('badge_id');
  set badgeId(String? value) => setField<String>('badge_id', value);

  String? get badgeName => getField<String>('badge_name');
  set badgeName(String? value) => setField<String>('badge_name', value);

  String? get badgeDescription => getField<String>('badge_description');
  set badgeDescription(String? value) =>
      setField<String>('badge_description', value);

  String? get badgeImgRef => getField<String>('badge_imgRef');
  set badgeImgRef(String? value) => setField<String>('badge_imgRef', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get updatedBy => getField<String>('updated_by');
  set updatedBy(String? value) => setField<String>('updated_by', value);

  int? get badgeMinPts => getField<int>('badge_minPts');
  set badgeMinPts(int? value) => setField<int>('badge_minPts', value);

  int? get badgeMaxPts => getField<int>('badge_maxPts');
  set badgeMaxPts(int? value) => setField<int>('badge_maxPts', value);

  int? get badgeLevel => getField<int>('badge_level');
  set badgeLevel(int? value) => setField<int>('badge_level', value);
}
