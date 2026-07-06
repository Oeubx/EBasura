import '../database.dart';

class ReportTable extends SupabaseTable<ReportRow> {
  @override
  String get tableName => 'Report';

  @override
  ReportRow createRow(Map<String, dynamic> data) => ReportRow(data);
}

class ReportRow extends SupabaseDataRow {
  ReportRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReportTable();

  String? get reportId => getField<String>('report_id');
  set reportId(String? value) => setField<String>('report_id', value);

  String? get reportDescription => getField<String>('report_description');
  set reportDescription(String? value) =>
      setField<String>('report_description', value);

  String? get reportRemarks => getField<String>('report_remarks');
  set reportRemarks(String? value) => setField<String>('report_remarks', value);

  DateTime get reportConductedDate =>
      getField<DateTime>('report_conductedDate')!;
  set reportConductedDate(DateTime value) =>
      setField<DateTime>('report_conductedDate', value);

  String get reportStreetNameRef => getField<String>('report_streetNameRef')!;
  set reportStreetNameRef(String value) =>
      setField<String>('report_streetNameRef', value);

  String get reporterUserRef => getField<String>('reporter_userRef')!;
  set reporterUserRef(String value) =>
      setField<String>('reporter_userRef', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
