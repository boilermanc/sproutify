import '../database.dart';

class UserplantActionsTable extends SupabaseTable<UserplantActionsRow> {
  @override
  String get tableName => 'userplant_actions';

  @override
  UserplantActionsRow createRow(Map<String, dynamic> data) =>
      UserplantActionsRow(data);
}

class UserplantActionsRow extends SupabaseDataRow {
  UserplantActionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserplantActionsTable();

  int get actionId => getField<int>('action_id')!;
  set actionId(int value) => setField<int>('action_id', value);

  int get userPlantId => getField<int>('user_plant_id')!;
  set userPlantId(int value) => setField<int>('user_plant_id', value);

  String get actionType => getField<String>('action_type')!;
  set actionType(String value) => setField<String>('action_type', value);

  DateTime? get actionDate => getField<DateTime>('action_date');
  set actionDate(DateTime? value) => setField<DateTime>('action_date', value);

  int? get actionQuantity => getField<int>('action_quantity');
  set actionQuantity(int? value) => setField<int>('action_quantity', value);
}
