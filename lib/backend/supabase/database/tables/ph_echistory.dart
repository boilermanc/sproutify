import '../database.dart';

class PhEchistoryTable extends SupabaseTable<PhEchistoryRow> {
  @override
  String get tableName => 'ph_echistory';

  @override
  PhEchistoryRow createRow(Map<String, dynamic> data) => PhEchistoryRow(data);
}

class PhEchistoryRow extends SupabaseDataRow {
  PhEchistoryRow(super.data);

  @override
  SupabaseTable get table => PhEchistoryTable();

  int get historyId => getField<int>('history_id')!;
  set historyId(int value) => setField<int>('history_id', value);

  int? get towerId => getField<int>('tower_id');
  set towerId(int? value) => setField<int>('tower_id', value);

  double? get phValue => getField<double>('ph_value');
  set phValue(double? value) => setField<double>('ph_value', value);

  double? get ecValue => getField<double>('ec_value');
  set ecValue(double? value) => setField<double>('ec_value', value);

  DateTime get timestamp => getField<DateTime>('timestamp')!;
  set timestamp(DateTime value) => setField<DateTime>('timestamp', value);
}
