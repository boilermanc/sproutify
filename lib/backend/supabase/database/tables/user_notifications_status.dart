import '../database.dart';

class UserNotificationsStatusTable
    extends SupabaseTable<UserNotificationsStatusRow> {
  @override
  String get tableName => 'user_notifications_status';

  @override
  UserNotificationsStatusRow createRow(Map<String, dynamic> data) =>
      UserNotificationsStatusRow(data);
}

class UserNotificationsStatusRow extends SupabaseDataRow {
  UserNotificationsStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserNotificationsStatusTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get notificationId => getField<int>('notification_id')!;
  set notificationId(int value) => setField<int>('notification_id', value);

  DateTime get readAt => getField<DateTime>('read_at')!;
  set readAt(DateTime value) => setField<DateTime>('read_at', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);
}
