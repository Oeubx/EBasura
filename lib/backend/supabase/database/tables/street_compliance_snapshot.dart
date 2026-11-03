import '../database.dart';

class StreetComplianceSnapshotTable
    extends SupabaseTable<StreetComplianceSnapshotRow> {
  @override
  String get tableName => 'street_compliance_snapshot';

  @override
  StreetComplianceSnapshotRow createRow(Map<String, dynamic> data) =>
      StreetComplianceSnapshotRow(data);
}

class StreetComplianceSnapshotRow extends SupabaseDataRow {
  StreetComplianceSnapshotRow(super.data);

  @override
  SupabaseTable get table => StreetComplianceSnapshotTable();

  int get snapshotId => getField<int>('snapshot_id')!;
  set snapshotId(int value) => setField<int>('snapshot_id', value);

  String get streetRef => getField<String>('street_ref')!;
  set streetRef(String value) => setField<String>('street_ref', value);

  DateTime get weekStart =>
      getField<DateTime>('week_start') ?? DateTime.now();
  set weekStart(DateTime value) => setField<DateTime>('week_start', value);

  int get verifiedScans => getField<int>('verified_scans') ?? 0;
  set verifiedScans(int value) => setField<int>('verified_scans', value);

  int get segregatedScans => getField<int>('segregated_scans') ?? 0;
  set segregatedScans(int value) => setField<int>('segregated_scans', value);

  int get validReports => getField<int>('valid_reports') ?? 0;
  set validReports(int value) => setField<int>('valid_reports', value);

  double? get sciWeek => getField<double>('sci_week');
  set sciWeek(double? value) => setField<double>('sci_week', value);

  double? get sciRolling4 => getField<double>('sci_rolling4');
  set sciRolling4(double? value) => setField<double>('sci_rolling4', value);

  String? get grade => getField<String>('grade');
  set grade(String? value) => setField<String>('grade', value);

  DateTime get computedAt =>
      getField<DateTime>('computed_at') ?? DateTime.now();
  set computedAt(DateTime value) => setField<DateTime>('computed_at', value);
}
