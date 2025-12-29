import '../database.dart';

class UserGardeningGoalsTable extends SupabaseTable<UserGardeningGoalsRow> {
  @override
  String get tableName => 'user_gardening_goals';

  @override
  UserGardeningGoalsRow createRow(Map<String, dynamic> data) =>
      UserGardeningGoalsRow(data);
}

class UserGardeningGoalsRow extends SupabaseDataRow {
  UserGardeningGoalsRow(super.data);

  @override
  SupabaseTable get table => UserGardeningGoalsTable();

  String get profileId => getField<String>('profile_id')!;
  set profileId(String value) => setField<String>('profile_id', value);

  int get goalId => getField<int>('goal_id')!;
  set goalId(int value) => setField<int>('goal_id', value);
}
