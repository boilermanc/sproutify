import '../database.dart';

class TowerGardensTable extends SupabaseTable<TowerGardensRow> {
  @override
  String get tableName => 'tower_gardens';

  @override
  TowerGardensRow createRow(Map<String, dynamic> data) => TowerGardensRow(data);
}

class TowerGardensRow extends SupabaseDataRow {
  TowerGardensRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TowerGardensTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get towerGarden => getField<String>('tower_garden');
  set towerGarden(String? value) => setField<String>('tower_garden', value);

  double? get ports => getField<double>('ports');
  set ports(double? value) => setField<double>('ports', value);

  String? get tgCorpImage => getField<String>('tg_corp_image');
  set tgCorpImage(String? value) => setField<String>('tg_corp_image', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);
}
