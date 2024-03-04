import '../database.dart';

class OutdoorPlantsTable extends SupabaseTable<OutdoorPlantsRow> {
  @override
  String get tableName => 'outdoor_plants';

  @override
  OutdoorPlantsRow createRow(Map<String, dynamic> data) =>
      OutdoorPlantsRow(data);
}

class OutdoorPlantsRow extends SupabaseDataRow {
  OutdoorPlantsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OutdoorPlantsTable();

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
