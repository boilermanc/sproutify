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

  int? get towerBrandId => getField<int>('tower_brand_id');
  set towerBrandId(int? value) => setField<int>('tower_brand_id', value);

  String get towerName => getField<String>('tower_name')!;
  set towerName(String value) => setField<String>('tower_name', value);

  int get portCount => getField<int>('port_count')!;
  set portCount(int value) => setField<int>('port_count', value);

  String? get indoorOutdoor => getField<String>('indoor_outdoor');
  set indoorOutdoor(String? value) => setField<String>('indoor_outdoor', value);

  bool? get archive => getField<bool>('archive');
  set archive(bool? value) => setField<bool>('archive', value);
}
