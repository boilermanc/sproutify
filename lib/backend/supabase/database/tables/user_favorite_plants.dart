import '../database.dart';

class UserFavoritePlantsTable extends SupabaseTable<UserFavoritePlantsRow> {
  @override
  String get tableName => 'user_favorite_plants';

  @override
  UserFavoritePlantsRow createRow(Map<String, dynamic> data) =>
      UserFavoritePlantsRow(data);
}

class UserFavoritePlantsRow extends SupabaseDataRow {
  UserFavoritePlantsRow(super.data);

  @override
  SupabaseTable get table => UserFavoritePlantsTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  String? get plantName => getField<String>('plant_name');
  set plantName(String? value) => setField<String>('plant_name', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  String? get plantImage => getField<String>('plant_image');
  set plantImage(String? value) => setField<String>('plant_image', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  bool? get isFavorite => getField<bool>('is_favorite');
  set isFavorite(bool? value) => setField<bool>('is_favorite', value);
}
