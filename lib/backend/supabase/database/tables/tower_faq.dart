import '../database.dart';

class TowerFaqTable extends SupabaseTable<TowerFaqRow> {
  @override
  String get tableName => 'tower_faq';

  @override
  TowerFaqRow createRow(Map<String, dynamic> data) => TowerFaqRow(data);
}

class TowerFaqRow extends SupabaseDataRow {
  TowerFaqRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TowerFaqTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get question => getField<String>('question');
  set question(String? value) => setField<String>('question', value);

  String? get answer => getField<String>('answer');
  set answer(String? value) => setField<String>('answer', value);

  String? get links => getField<String>('links');
  set links(String? value) => setField<String>('links', value);
}
