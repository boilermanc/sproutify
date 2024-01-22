import '../database.dart';

class PlantRatingsTable extends SupabaseTable<PlantRatingsRow> {
  @override
  String get tableName => 'plant_ratings';

  @override
  PlantRatingsRow createRow(Map<String, dynamic> data) => PlantRatingsRow(data);
}

class PlantRatingsRow extends SupabaseDataRow {
  PlantRatingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlantRatingsTable();

  int get ratingId => getField<int>('rating_id')!;
  set ratingId(int value) => setField<int>('rating_id', value);

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  int? get userPlantId => getField<int>('user_plant_id');
  set userPlantId(int? value) => setField<int>('user_plant_id', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
