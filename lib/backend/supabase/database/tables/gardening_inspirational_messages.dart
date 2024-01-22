import '../database.dart';

class GardeningInspirationalMessagesTable
    extends SupabaseTable<GardeningInspirationalMessagesRow> {
  @override
  String get tableName => 'gardening_inspirational_messages';

  @override
  GardeningInspirationalMessagesRow createRow(Map<String, dynamic> data) =>
      GardeningInspirationalMessagesRow(data);
}

class GardeningInspirationalMessagesRow extends SupabaseDataRow {
  GardeningInspirationalMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GardeningInspirationalMessagesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  String? get messageDate => getField<String>('message_date');
  set messageDate(String? value) => setField<String>('message_date', value);
}
