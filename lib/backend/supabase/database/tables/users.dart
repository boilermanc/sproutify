import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  int get userId => getField<int>('user_id')!;
  set userId(int value) => setField<int>('user_id', value);

  bool? get isAdmin => getField<bool>('is_admin');
  set isAdmin(bool? value) => setField<bool>('is_admin', value);

  String get role => getField<String>('role')!;
  set role(String value) => setField<String>('role', value);
}
