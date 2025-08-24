import '../database.dart';

class GardeningInspirationalMessagesBackupTable
    extends SupabaseTable<GardeningInspirationalMessagesBackupRow> {
  @override
  String get tableName => 'gardening_inspirational_messages_backup';

  @override
  GardeningInspirationalMessagesBackupRow createRow(
          Map<String, dynamic> data) =>
      GardeningInspirationalMessagesBackupRow(data);
}

class GardeningInspirationalMessagesBackupRow extends SupabaseDataRow {
  GardeningInspirationalMessagesBackupRow(Map<String, dynamic> data)
      : super(data);

  @override
  SupabaseTable get table => GardeningInspirationalMessagesBackupTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get body => getField<String>('body');
  set body(String? value) => setField<String>('body', value);

  String? get messageDate => getField<String>('message_date');
  set messageDate(String? value) => setField<String>('message_date', value);
}
