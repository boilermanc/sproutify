import '../database.dart';

class UserGardeningPlantPreferencesTable
    extends SupabaseTable<UserGardeningPlantPreferencesRow> {
  @override
  String get tableName => 'user_gardening_plant_preferences';

  @override
  UserGardeningPlantPreferencesRow createRow(Map<String, dynamic> data) =>
      UserGardeningPlantPreferencesRow(data);
}

class UserGardeningPlantPreferencesRow extends SupabaseDataRow {
  UserGardeningPlantPreferencesRow(super.data);

  @override
  SupabaseTable get table => UserGardeningPlantPreferencesTable();

  String get profileId => getField<String>('profile_id')!;
  set profileId(String value) => setField<String>('profile_id', value);

  int get plantTypeId => getField<int>('plant_type_id')!;
  set plantTypeId(int value) => setField<int>('plant_type_id', value);
}
