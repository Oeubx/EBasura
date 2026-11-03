import '../database.dart';

class PointsLedgerTable extends SupabaseTable<PointsLedgerRow> {
  @override
  String get tableName => 'points_ledger';

  @override
  PointsLedgerRow createRow(Map<String, dynamic> data) =>
      PointsLedgerRow(data);
}

class PointsLedgerRow extends SupabaseDataRow {
  PointsLedgerRow(super.data);

  @override
  SupabaseTable get table => PointsLedgerTable();

  int get ledgerId => getField<int>('ledger_id') ?? 0;
  set ledgerId(int value) => setField<int>('ledger_id', value);

  String get userId => getField<String>('user_id') ?? '';
  set userId(String value) => setField<String>('user_id', value);

  int get points => getField<int>('points') ?? 0;
  set points(int value) => setField<int>('points', value);

  String get reasonCode => getField<String>('reason_code') ?? '';
  set reasonCode(String value) => setField<String>('reason_code', value);

  String? get imageId => getField<String>('image_id');
  set imageId(String? value) => setField<String>('image_id', value);

  String? get reportId => getField<String>('report_id');
  set reportId(String? value) => setField<String>('report_id', value);

  String? get streetRef => getField<String>('street_ref');
  set streetRef(String? value) => setField<String>('street_ref', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime get createdAt => getField<DateTime>('created_at') ?? DateTime.now();
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
