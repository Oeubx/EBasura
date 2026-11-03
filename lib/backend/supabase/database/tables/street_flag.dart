import '../database.dart';

class StreetFlagTable extends SupabaseTable<StreetFlagRow> {
  @override
  String get tableName => 'street_flag';

  @override
  StreetFlagRow createRow(Map<String, dynamic> data) => StreetFlagRow(data);
}

class StreetFlagRow extends SupabaseDataRow {
  StreetFlagRow(super.data);

  @override
  SupabaseTable get table => StreetFlagTable();

  int get flagId => getField<int>('flag_id')!;
  set flagId(int value) => setField<int>('flag_id', value);

  String get streetRef => getField<String>('street_ref')!;
  set streetRef(String value) => setField<String>('street_ref', value);

  DateTime get openedWeek =>
      getField<DateTime>('opened_week') ?? DateTime.now();
  set openedWeek(DateTime value) => setField<DateTime>('opened_week', value);

  String get status => getField<String>('status') ?? 'open';
  set status(String value) => setField<String>('status', value);

  String? get actionNote => getField<String>('action_note');
  set actionNote(String? value) => setField<String>('action_note', value);

  String? get assignedTo => getField<String>('assigned_to');
  set assignedTo(String? value) => setField<String>('assigned_to', value);

  DateTime? get resolvedAt => getField<DateTime>('resolved_at');
  set resolvedAt(DateTime? value) => setField<DateTime>('resolved_at', value);

  DateTime get createdAt =>
      getField<DateTime>('created_at') ?? DateTime.now();
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
