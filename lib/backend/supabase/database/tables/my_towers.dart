import '../database.dart';

class MyTowersTable extends SupabaseTable<MyTowersRow> {
  @override
  String get tableName => 'my_towers';

  @override
  MyTowersRow createRow(Map<String, dynamic> data) => MyTowersRow(data);
}

class MyTowersRow extends SupabaseDataRow {
  MyTowersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MyTowersTable();

  int get towerId => getField<int>('tower_id')!;
  set towerId(int value) => setField<int>('tower_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get towerGardenId => getField<int>('tower_garden_id');
  set towerGardenId(int? value) => setField<int>('tower_garden_id', value);

  String get towerName => getField<String>('tower_name')!;
  set towerName(String value) => setField<String>('tower_name', value);

  String? get indoorOutdoor => getField<String>('indoor_outdoor');
  set indoorOutdoor(String? value) => setField<String>('indoor_outdoor', value);
}
