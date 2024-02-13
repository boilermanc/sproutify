import '../database.dart';

class UserplantsTable extends SupabaseTable<UserplantsRow> {
  @override
  String get tableName => 'userplants';

  @override
  UserplantsRow createRow(Map<String, dynamic> data) => UserplantsRow(data);
}

class UserplantsRow extends SupabaseDataRow {
  UserplantsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserplantsTable();

  int get userPlantId => getField<int>('user_plant_id')!;
  set userPlantId(int value) => setField<int>('user_plant_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get plantId => getField<int>('plant_id');
  set plantId(int? value) => setField<int>('plant_id', value);

  bool? get archived => getField<bool>('archived');
  set archived(bool? value) => setField<bool>('archived', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  double? get plantCost => getField<double>('plant_cost');
  set plantCost(double? value) => setField<double>('plant_cost', value);

  DateTime? get addedOn => getField<DateTime>('added_on');
  set addedOn(DateTime? value) => setField<DateTime>('added_on', value);
}
