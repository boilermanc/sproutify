import '../database.dart';

class PlantCategoryTable extends SupabaseTable<PlantCategoryRow> {
  @override
  String get tableName => 'plant_category';

  @override
  PlantCategoryRow createRow(Map<String, dynamic> data) =>
      PlantCategoryRow(data);
}

class PlantCategoryRow extends SupabaseDataRow {
  PlantCategoryRow(super.data);

  @override
  SupabaseTable get table => PlantCategoryTable();

  int get categoryId => getField<int>('category_id')!;
  set categoryId(int value) => setField<int>('category_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get plantCatagory => getField<String>('plant_catagory');
  set plantCatagory(String? value) => setField<String>('plant_catagory', value);

  String? get desc => getField<String>('desc');
  set desc(String? value) => setField<String>('desc', value);
}
