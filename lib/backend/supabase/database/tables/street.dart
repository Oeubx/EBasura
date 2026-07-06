import '../database.dart';

class StreetTable extends SupabaseTable<StreetRow> {
  @override
  String get tableName => 'Street';

  @override
  StreetRow createRow(Map<String, dynamic> data) => StreetRow(data);
}

class StreetRow extends SupabaseDataRow {
  StreetRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StreetTable();

  String get streetName => getField<String>('street_name')!;
  set streetName(String value) => setField<String>('street_name', value);

  String? get streetId => getField<String>('street_id');
  set streetId(String? value) => setField<String>('street_id', value);

  String? get streetDescription => getField<String>('street_description');
  set streetDescription(String? value) =>
      setField<String>('street_description', value);

  String? get lastUpdatedBy => getField<String>('last_updatedBy');
  set lastUpdatedBy(String? value) => setField<String>('last_updatedBy', value);

  DateTime? get lastUpdatedTime => getField<DateTime>('last_updatedTime');
  set lastUpdatedTime(DateTime? value) =>
      setField<DateTime>('last_updatedTime', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get hasStorage => getField<bool>('has_storage');
  set hasStorage(bool? value) => setField<bool>('has_storage', value);
}
