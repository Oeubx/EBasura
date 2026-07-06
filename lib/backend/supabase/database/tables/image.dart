import '../database.dart';

class ImageTable extends SupabaseTable<ImageRow> {
  @override
  String get tableName => 'Image';

  @override
  ImageRow createRow(Map<String, dynamic> data) => ImageRow(data);
}

class ImageRow extends SupabaseDataRow {
  ImageRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ImageTable();

  String? get imageId => getField<String>('image_id');
  set imageId(String? value) => setField<String>('image_id', value);

  String get imgUploader => getField<String>('img_uploader')!;
  set imgUploader(String value) => setField<String>('img_uploader', value);

  String get imgStreetNameRef => getField<String>('img_streetNameRef')!;
  set imgStreetNameRef(String value) =>
      setField<String>('img_streetNameRef', value);

  String get imgReferenceLink => getField<String>('img_reference_link')!;
  set imgReferenceLink(String value) =>
      setField<String>('img_reference_link', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get remark => getField<String>('remark');
  set remark(String? value) => setField<String>('remark', value);

  String? get updatedBy => getField<String>('updated_by');
  set updatedBy(String? value) => setField<String>('updated_by', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get allowFlagging => getField<bool>('allowFlagging');
  set allowFlagging(bool? value) => setField<bool>('allowFlagging', value);

  bool? get isSegregated => getField<bool>('isSegregated');
  set isSegregated(bool? value) => setField<bool>('isSegregated', value);

  bool? get categoryRecycling => getField<bool>('category_recycling');
  set categoryRecycling(bool? value) =>
      setField<bool>('category_recycling', value);

  bool? get categoryBiode => getField<bool>('category_biode');
  set categoryBiode(bool? value) => setField<bool>('category_biode', value);

  bool? get categoryNonbiode => getField<bool>('category_nonbiode');
  set categoryNonbiode(bool? value) =>
      setField<bool>('category_nonbiode', value);

  DateTime? get createdAtDate => getField<DateTime>('created_atDate');
  set createdAtDate(DateTime? value) =>
      setField<DateTime>('created_atDate', value);
}
