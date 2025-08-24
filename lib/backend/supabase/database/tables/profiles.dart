import '../database.dart';

class ProfilesTable extends SupabaseTable<ProfilesRow> {
  @override
  String get tableName => 'profiles';

  @override
  ProfilesRow createRow(Map<String, dynamic> data) => ProfilesRow(data);
}

class ProfilesRow extends SupabaseDataRow {
  ProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProfilesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get username => getField<String>('username');
  set username(String? value) => setField<String>('username', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get addressLine1 => getField<String>('address_line1');
  set addressLine1(String? value) => setField<String>('address_line1', value);

  String? get addressLine2 => getField<String>('address_line2');
  set addressLine2(String? value) => setField<String>('address_line2', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get postalCode => getField<String>('postal_code');
  set postalCode(String? value) => setField<String>('postal_code', value);

  DateTime? get lastNotificationReadTime =>
      getField<DateTime>('last_notification_read_time');
  set lastNotificationReadTime(DateTime? value) =>
      setField<DateTime>('last_notification_read_time', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get gardeningExperience => getField<String>('gardening_experience');
  set gardeningExperience(String? value) =>
      setField<String>('gardening_experience', value);

  int? get mailerliteGroupId => getField<int>('mailerlite_group_id');
  set mailerliteGroupId(int? value) =>
      setField<int>('mailerlite_group_id', value);
}
