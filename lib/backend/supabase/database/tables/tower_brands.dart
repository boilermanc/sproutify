import '../database.dart';

class TowerBrandsTable extends SupabaseTable<TowerBrandsRow> {
  @override
  String get tableName => 'tower_brands';

  @override
  TowerBrandsRow createRow(Map<String, dynamic> data) => TowerBrandsRow(data);
}

class TowerBrandsRow extends SupabaseDataRow {
  TowerBrandsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TowerBrandsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get brandName => getField<String>('brand_name');
  set brandName(String? value) => setField<String>('brand_name', value);

  String? get brandLogoUrl => getField<String>('brand_logo_url');
  set brandLogoUrl(String? value) => setField<String>('brand_logo_url', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  int get displayOrder => getField<int>('display_order')!;
  set displayOrder(int value) => setField<int>('display_order', value);

  bool get allowCustomName => getField<bool>('allow_custom_name')!;
  set allowCustomName(bool value) => setField<bool>('allow_custom_name', value);
}
