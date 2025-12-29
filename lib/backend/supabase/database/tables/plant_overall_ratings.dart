import '../database.dart';

class PlantOverallRatingsTable extends SupabaseTable<PlantOverallRatingsRow> {
  @override
  String get tableName => 'plant_overall_ratings';

  @override
  PlantOverallRatingsRow createRow(Map<String, dynamic> data) =>
      PlantOverallRatingsRow(data);
}

class PlantOverallRatingsRow extends SupabaseDataRow {
  PlantOverallRatingsRow(super.data);

  @override
  SupabaseTable get table => PlantOverallRatingsTable();

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  double? get averageRating => getField<double>('average_rating');
  set averageRating(double? value) => setField<double>('average_rating', value);

  int? get totalRatings => getField<int>('total_ratings');
  set totalRatings(int? value) => setField<int>('total_ratings', value);

  double? get lowestRating => getField<double>('lowest_rating');
  set lowestRating(double? value) => setField<double>('lowest_rating', value);

  double? get highestRating => getField<double>('highest_rating');
  set highestRating(double? value) => setField<double>('highest_rating', value);
}
