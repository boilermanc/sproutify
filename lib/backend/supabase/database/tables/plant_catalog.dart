import '../database.dart';

class PlantCatalogTable extends SupabaseTable<PlantCatalogRow> {
  @override
  String get tableName => 'plant_catalog';

  @override
  PlantCatalogRow createRow(Map<String, dynamic> data) => PlantCatalogRow(data);
}

class PlantCatalogRow extends SupabaseDataRow {
  PlantCatalogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlantCatalogTable();

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get plantUrl => getField<String>('plant_url');
  set plantUrl(String? value) => setField<String>('plant_url', value);
}
