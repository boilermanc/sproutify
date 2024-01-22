import '../database.dart';

class UserplantdetailsTable extends SupabaseTable<UserplantdetailsRow> {
  @override
  String get tableName => 'userplantdetails';

  @override
  UserplantdetailsRow createRow(Map<String, dynamic> data) =>
      UserplantdetailsRow(data);
}

class UserplantdetailsRow extends SupabaseDataRow {
  UserplantdetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserplantdetailsTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);

  int? get userPlantId => getField<int>('user_plant_id');
  set userPlantId(int? value) => setField<int>('user_plant_id', value);

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  String? get plantImage => getField<String>('plant_image');
  set plantImage(String? value) => setField<String>('plant_image', value);

  bool? get archived => getField<bool>('archived');
  set archived(bool? value) => setField<bool>('archived', value);

  double? get userRating => getField<double>('user_rating');
  set userRating(double? value) => setField<double>('user_rating', value);

  bool? get isFavorite => getField<bool>('is_favorite');
  set isFavorite(bool? value) => setField<bool>('is_favorite', value);

  DateTime? get entryTimestamp => getField<DateTime>('entry_timestamp');
  set entryTimestamp(DateTime? value) =>
      setField<DateTime>('entry_timestamp', value);

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

  String? get indoorOutdoor => getField<String>('indoor_outdoor');
  set indoorOutdoor(String? value) => setField<String>('indoor_outdoor', value);
}
