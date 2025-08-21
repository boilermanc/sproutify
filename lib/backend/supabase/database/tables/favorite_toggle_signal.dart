import '../database.dart';

class FavoriteToggleSignalTable extends SupabaseTable<FavoriteToggleSignalRow> {
  @override
  String get tableName => 'favorite_toggle_signal';

  @override
  FavoriteToggleSignalRow createRow(Map<String, dynamic> data) =>
      FavoriteToggleSignalRow(data);
}

class FavoriteToggleSignalRow extends SupabaseDataRow {
  FavoriteToggleSignalRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FavoriteToggleSignalTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get plantId => getField<int>('plant_id')!;
  set plantId(int value) => setField<int>('plant_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
