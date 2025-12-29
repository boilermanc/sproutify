import '../database.dart';

class ViewPlantDetailsByCategoryTable
    extends SupabaseTable<ViewPlantDetailsByCategoryRow> {
  @override
  String get tableName => 'view_plant_details_by_category';

  @override
  ViewPlantDetailsByCategoryRow createRow(Map<String, dynamic> data) =>
      ViewPlantDetailsByCategoryRow(data);
}

class ViewPlantDetailsByCategoryRow extends SupabaseDataRow {
  ViewPlantDetailsByCategoryRow(super.data);

  @override
  SupabaseTable get table => ViewPlantDetailsByCategoryTable();

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  String? get growingSeason => getField<String>('growing_season');
  set growingSeason(String? value) => setField<String>('growing_season', value);

  String? get harvestMethod => getField<String>('harvest_method');
  set harvestMethod(String? value) => setField<String>('harvest_method', value);

  String? get firstHarvest => getField<String>('first_harvest');
  set firstHarvest(String? value) => setField<String>('first_harvest', value);

  String? get finalHarvest => getField<String>('final_harvest');
  set finalHarvest(String? value) => setField<String>('final_harvest', value);

  String? get bestPlacement => getField<String>('best_placement');
  set bestPlacement(String? value) => setField<String>('best_placement', value);

  String? get plantImage => getField<String>('plant_image');
  set plantImage(String? value) => setField<String>('plant_image', value);

  String? get longDescription => getField<String>('long_description');
  set longDescription(String? value) =>
      setField<String>('long_description', value);

  String? get indoorOutdoor => getField<String>('indoor_outdoor');
  set indoorOutdoor(String? value) => setField<String>('indoor_outdoor', value);

  double? get averageRating => getField<double>('average_rating');
  set averageRating(double? value) => setField<double>('average_rating', value);

  int? get categoryId => getField<int>('category_id');
  set categoryId(int? value) => setField<int>('category_id', value);
}
