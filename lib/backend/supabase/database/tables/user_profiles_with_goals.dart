import '../database.dart';

class UserProfilesWithGoalsTable
    extends SupabaseTable<UserProfilesWithGoalsRow> {
  @override
  String get tableName => 'user_profiles_with_goals';

  @override
  UserProfilesWithGoalsRow createRow(Map<String, dynamic> data) =>
      UserProfilesWithGoalsRow(data);
}

class UserProfilesWithGoalsRow extends SupabaseDataRow {
  UserProfilesWithGoalsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserProfilesWithGoalsTable();

  String? get profileId => getField<String>('profile_id');
  set profileId(String? value) => setField<String>('profile_id', value);

  String? get username => getField<String>('username');
  set username(String? value) => setField<String>('username', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get gardeningGoals => getField<String>('gardening_goals');
  set gardeningGoals(String? value) =>
      setField<String>('gardening_goals', value);
}
