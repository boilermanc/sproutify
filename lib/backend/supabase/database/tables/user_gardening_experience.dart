import '../database.dart';

class UserGardeningExperienceTable
    extends SupabaseTable<UserGardeningExperienceRow> {
  @override
  String get tableName => 'user_gardening_experience';

  @override
  UserGardeningExperienceRow createRow(Map<String, dynamic> data) =>
      UserGardeningExperienceRow(data);
}

class UserGardeningExperienceRow extends SupabaseDataRow {
  UserGardeningExperienceRow(super.data);

  @override
  SupabaseTable get table => UserGardeningExperienceTable();

  String get profileId => getField<String>('profile_id')!;
  set profileId(String value) => setField<String>('profile_id', value);

  int get levelId => getField<int>('level_id')!;
  set levelId(int value) => setField<int>('level_id', value);
}
