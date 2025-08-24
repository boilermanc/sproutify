import '../database.dart';

class PlantCategoryRelationTable
    extends SupabaseTable<PlantCategoryRelationRow> {
  @override
  String get tableName => 'plant_category_relation';

  @override
  PlantCategoryRelationRow createRow(Map<String, dynamic> data) =>
      PlantCategoryRelationRow(data);
}

class PlantCategoryRelationRow extends SupabaseDataRow {
  PlantCategoryRelationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlantCategoryRelationTable();

  int get plantId => getField<int>('plant_id')!;
  set plantId(int value) => setField<int>('plant_id', value);

  int get categoryId => getField<int>('category_id')!;
  set categoryId(int value) => setField<int>('category_id', value);
}
