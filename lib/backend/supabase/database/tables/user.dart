import '../database.dart';

class UserTable extends SupabaseTable<UserRow> {
  @override
  String get tableName => 'User';

  @override
  UserRow createRow(Map<String, dynamic> data) => UserRow(data);
}

class UserRow extends SupabaseDataRow {
  UserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get userName => getField<String>('user_name');
  set userName(String? value) => setField<String>('user_name', value);

  String? get userType => getField<String>('user_type');
  set userType(String? value) => setField<String>('user_type', value);

  String? get userStreetNameRef => getField<String>('user_streetNameRef');
  set userStreetNameRef(String? value) =>
      setField<String>('user_streetNameRef', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);
}
