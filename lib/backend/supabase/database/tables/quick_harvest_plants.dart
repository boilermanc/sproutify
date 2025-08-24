import '../database.dart';

class QuickHarvestPlantsTable extends SupabaseTable<QuickHarvestPlantsRow> {
  @override
  String get tableName => 'quick_harvest_plants';

  @override
  QuickHarvestPlantsRow createRow(Map<String, dynamic> data) =>
      QuickHarvestPlantsRow(data);
}

class QuickHarvestPlantsRow extends SupabaseDataRow {
  QuickHarvestPlantsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => QuickHarvestPlantsTable();

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  String? get firstHarvest => getField<String>('first_harvest');
  set firstHarvest(String? value) => setField<String>('first_harvest', value);

  String? get finalHarvest => getField<String>('final_harvest');
  set finalHarvest(String? value) => setField<String>('final_harvest', value);

  String? get plantImage => getField<String>('plant_image');
  set plantImage(String? value) => setField<String>('plant_image', value);

  double? get averageRating => getField<double>('average_rating');
  set averageRating(double? value) => setField<double>('average_rating', value);
}
