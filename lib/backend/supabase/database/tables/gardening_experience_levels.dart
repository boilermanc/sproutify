import '../database.dart';

class GardeningExperienceLevelsTable
    extends SupabaseTable<GardeningExperienceLevelsRow> {
  @override
  String get tableName => 'gardening_experience_levels';

  @override
  GardeningExperienceLevelsRow createRow(Map<String, dynamic> data) =>
      GardeningExperienceLevelsRow(data);
}

class GardeningExperienceLevelsRow extends SupabaseDataRow {
  GardeningExperienceLevelsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GardeningExperienceLevelsTable();

  int get levelId => getField<int>('level_id')!;
  set levelId(int value) => setField<int>('level_id', value);

  String get levelDescription => getField<String>('level_description')!;
  set levelDescription(String value) =>
      setField<String>('level_description', value);

  int? get mailerliteGroupId => getField<int>('mailerlite_group_id');
  set mailerliteGroupId(int? value) =>
      setField<int>('mailerlite_group_id', value);
}
