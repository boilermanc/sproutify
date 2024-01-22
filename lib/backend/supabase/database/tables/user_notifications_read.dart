import '../database.dart';

class UserNotificationsReadTable
    extends SupabaseTable<UserNotificationsReadRow> {
  @override
  String get tableName => 'user_notifications_read';

  @override
  UserNotificationsReadRow createRow(Map<String, dynamic> data) =>
      UserNotificationsReadRow(data);
}

class UserNotificationsReadRow extends SupabaseDataRow {
  UserNotificationsReadRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserNotificationsReadTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get notificationId => getField<int>('notification_id')!;
  set notificationId(int value) => setField<int>('notification_id', value);

  DateTime get readAt => getField<DateTime>('read_at')!;
  set readAt(DateTime value) => setField<DateTime>('read_at', value);
}
