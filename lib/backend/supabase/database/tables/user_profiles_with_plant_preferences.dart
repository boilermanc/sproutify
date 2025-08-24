import '../database.dart';

class UserProfilesWithPlantPreferencesTable
    extends SupabaseTable<UserProfilesWithPlantPreferencesRow> {
  @override
  String get tableName => 'user_profiles_with_plant_preferences';

  @override
  UserProfilesWithPlantPreferencesRow createRow(Map<String, dynamic> data) =>
      UserProfilesWithPlantPreferencesRow(data);
}

class UserProfilesWithPlantPreferencesRow extends SupabaseDataRow {
  UserProfilesWithPlantPreferencesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserProfilesWithPlantPreferencesTable();

  String? get profileId => getField<String>('profile_id');
  set profileId(String? value) => setField<String>('profile_id', value);

  String? get username => getField<String>('username');
  set username(String? value) => setField<String>('username', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get plantPreferences => getField<String>('plant_preferences');
  set plantPreferences(String? value) =>
      setField<String>('plant_preferences', value);
}
