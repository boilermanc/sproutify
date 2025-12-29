import '../database.dart';

class HighlyRatedPicksTable extends SupabaseTable<HighlyRatedPicksRow> {
  @override
  String get tableName => 'highly_rated_picks';

  @override
  HighlyRatedPicksRow createRow(Map<String, dynamic> data) =>
      HighlyRatedPicksRow(data);
}

class HighlyRatedPicksRow extends SupabaseDataRow {
  HighlyRatedPicksRow(super.data);

  @override
  SupabaseTable get table => HighlyRatedPicksTable();

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  double? get averageRating => getField<double>('average_rating');
  set averageRating(double? value) => setField<double>('average_rating', value);

  String? get plantImage => getField<String>('plant_image');
  set plantImage(String? value) => setField<String>('plant_image', value);
}
