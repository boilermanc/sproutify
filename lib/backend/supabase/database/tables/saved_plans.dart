import '../database.dart';

class SavedPlansTable extends SupabaseTable<SavedPlansRow> {
  @override
  String get tableName => 'saved_plans';

  @override
  SavedPlansRow createRow(Map<String, dynamic> data) => SavedPlansRow(data);
}

class SavedPlansRow extends SupabaseDataRow {
  SavedPlansRow(super.data);

  @override
  SupabaseTable get table => SavedPlansTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get towerId => getField<int>('tower_id');
  set towerId(int? value) => setField<int>('tower_id', value);

  String? get planName => getField<String>('plan_name');
  set planName(String? value) => setField<String>('plan_name', value);

  String? get planData => getField<String>('plan_data');
  set planData(String? value) => setField<String>('plan_data', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
