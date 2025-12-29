import '../database.dart';

class IndoorPlantsTable extends SupabaseTable<IndoorPlantsRow> {
  @override
  String get tableName => 'indoor_plants';

  @override
  IndoorPlantsRow createRow(Map<String, dynamic> data) => IndoorPlantsRow(data);
}

class IndoorPlantsRow extends SupabaseDataRow {
  IndoorPlantsRow(super.data);

  @override
  SupabaseTable get table => IndoorPlantsTable();

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  String? get indoorOutdoor => getField<String>('indoor_outdoor');
  set indoorOutdoor(String? value) => setField<String>('indoor_outdoor', value);

  String? get plantImage => getField<String>('plant_image');
  set plantImage(String? value) => setField<String>('plant_image', value);

  double? get averageRating => getField<double>('average_rating');
  set averageRating(double? value) => setField<double>('average_rating', value);
}
