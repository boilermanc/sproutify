import '../database.dart';

class IndoorOutdoorPlantsTable extends SupabaseTable<IndoorOutdoorPlantsRow> {
  @override
  String get tableName => 'indoor_outdoor_plants';

  @override
  IndoorOutdoorPlantsRow createRow(Map<String, dynamic> data) =>
      IndoorOutdoorPlantsRow(data);
}

class IndoorOutdoorPlantsRow extends SupabaseDataRow {
  IndoorOutdoorPlantsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => IndoorOutdoorPlantsTable();

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
