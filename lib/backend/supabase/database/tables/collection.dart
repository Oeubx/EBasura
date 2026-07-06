import '../database.dart';

class CollectionTable extends SupabaseTable<CollectionRow> {
  @override
  String get tableName => 'Collection';

  @override
  CollectionRow createRow(Map<String, dynamic> data) => CollectionRow(data);
}

class CollectionRow extends SupabaseDataRow {
  CollectionRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CollectionTable();

  String? get collectionId => getField<String>('collection_id');
  set collectionId(String? value) => setField<String>('collection_id', value);

  String? get collectionDescription =>
      getField<String>('collection_description');
  set collectionDescription(String? value) =>
      setField<String>('collection_description', value);

  String get collectionStreetNameRef =>
      getField<String>('collection_streetNameRef')!;
  set collectionStreetNameRef(String value) =>
      setField<String>('collection_streetNameRef', value);

  String get collectionDay => getField<String>('collection_day')!;
  set collectionDay(String value) => setField<String>('collection_day', value);

  PostgresTime get collectionTimeDurationStart =>
      getField<PostgresTime>('collection_timeDuration_start')!;
  set collectionTimeDurationStart(PostgresTime value) =>
      setField<PostgresTime>('collection_timeDuration_start', value);

  PostgresTime get collectionTimeDurationEnd =>
      getField<PostgresTime>('collection_timeDuration_end')!;
  set collectionTimeDurationEnd(PostgresTime value) =>
      setField<PostgresTime>('collection_timeDuration_end', value);

  String get lastUpdatedBy => getField<String>('last_updatedBy')!;
  set lastUpdatedBy(String value) => setField<String>('last_updatedBy', value);

  DateTime? get lastUpdatedTime => getField<DateTime>('last_updatedTime');
  set lastUpdatedTime(DateTime? value) =>
      setField<DateTime>('last_updatedTime', value);

  List<String> get collectorNamesReference =>
      getListField<String>('collectorNames_reference');
  set collectorNamesReference(List<String>? value) =>
      setListField<String>('collectorNames_reference', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
