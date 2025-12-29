import '../database.dart';

class GardeningGoalsTable extends SupabaseTable<GardeningGoalsRow> {
  @override
  String get tableName => 'gardening_goals';

  @override
  GardeningGoalsRow createRow(Map<String, dynamic> data) =>
      GardeningGoalsRow(data);
}

class GardeningGoalsRow extends SupabaseDataRow {
  GardeningGoalsRow(super.data);

  @override
  SupabaseTable get table => GardeningGoalsTable();

  int get goalId => getField<int>('goal_id')!;
  set goalId(int value) => setField<int>('goal_id', value);

  String get goalDescription => getField<String>('goal_description')!;
  set goalDescription(String value) =>
      setField<String>('goal_description', value);
}
