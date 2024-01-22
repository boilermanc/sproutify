import '../database.dart';

class AllUnreadNotificationsTable
    extends SupabaseTable<AllUnreadNotificationsRow> {
  @override
  String get tableName => 'all_unread_notifications';

  @override
  AllUnreadNotificationsRow createRow(Map<String, dynamic> data) =>
      AllUnreadNotificationsRow(data);
}

class AllUnreadNotificationsRow extends SupabaseDataRow {
  AllUnreadNotificationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AllUnreadNotificationsTable();

  int? get notificationId => getField<int>('notification_id');
  set notificationId(int? value) => setField<int>('notification_id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get timeCreated => getField<DateTime>('time_created');
  set timeCreated(DateTime? value) => setField<DateTime>('time_created', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
