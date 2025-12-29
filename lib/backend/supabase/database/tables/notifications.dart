import '../database.dart';

class NotificationsTable extends SupabaseTable<NotificationsRow> {
  @override
  String get tableName => 'notifications';

  @override
  NotificationsRow createRow(Map<String, dynamic> data) =>
      NotificationsRow(data);
}

class NotificationsRow extends SupabaseDataRow {
  NotificationsRow(super.data);

  @override
  SupabaseTable get table => NotificationsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime get timeCreated => getField<DateTime>('time_created')!;
  set timeCreated(DateTime value) => setField<DateTime>('time_created', value);

  String? get formattedTimeCreated =>
      getField<String>('formatted_time_created');
  set formattedTimeCreated(String? value) =>
      setField<String>('formatted_time_created', value);

  bool get status => getField<bool>('status')!;
  set status(bool value) => setField<bool>('status', value);
}
