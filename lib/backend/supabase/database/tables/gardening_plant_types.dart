import '../database.dart';

class GardeningPlantTypesTable extends SupabaseTable<GardeningPlantTypesRow> {
  @override
  String get tableName => 'gardening_plant_types';

  @override
  GardeningPlantTypesRow createRow(Map<String, dynamic> data) =>
      GardeningPlantTypesRow(data);
}

class GardeningPlantTypesRow extends SupabaseDataRow {
  GardeningPlantTypesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GardeningPlantTypesTable();

  int get plantTypeId => getField<int>('plant_type_id')!;
  set plantTypeId(int value) => setField<int>('plant_type_id', value);

  String get plantTypeDescription =>
      getField<String>('plant_type_description')!;
  set plantTypeDescription(String value) =>
      setField<String>('plant_type_description', value);
}
