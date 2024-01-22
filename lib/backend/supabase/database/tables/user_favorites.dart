import '../database.dart';

class UserFavoritesTable extends SupabaseTable<UserFavoritesRow> {
  @override
  String get tableName => 'user_favorites';

  @override
  UserFavoritesRow createRow(Map<String, dynamic> data) =>
      UserFavoritesRow(data);
}

class UserFavoritesRow extends SupabaseDataRow {
  UserFavoritesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserFavoritesTable();

  int get favoriteId => getField<int>('favorite_id')!;
  set favoriteId(int value) => setField<int>('favorite_id', value);

  int get plantId => getField<int>('plant_id')!;
  set plantId(int value) => setField<int>('plant_id', value);

  bool? get isFavorite => getField<bool>('is_favorite');
  set isFavorite(bool? value) => setField<bool>('is_favorite', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
