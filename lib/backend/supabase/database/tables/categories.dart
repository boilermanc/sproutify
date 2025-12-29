import '../database.dart';

class CategoriesTable extends SupabaseTable<CategoriesRow> {
  @override
  String get tableName => 'categories';

  @override
  CategoriesRow createRow(Map<String, dynamic> data) => CategoriesRow(data);
}

class CategoriesRow extends SupabaseDataRow {
  CategoriesRow(super.data);

  @override
  SupabaseTable get table => CategoriesTable();

  int get categoryid => getField<int>('categoryid')!;
  set categoryid(int value) => setField<int>('categoryid', value);

  String get categoryname => getField<String>('categoryname')!;
  set categoryname(String value) => setField<String>('categoryname', value);

  String? get categoryimageurl => getField<String>('categoryimageurl');
  set categoryimageurl(String? value) =>
      setField<String>('categoryimageurl', value);

  String? get categorydescription => getField<String>('categorydescription');
  set categorydescription(String? value) =>
      setField<String>('categorydescription', value);
}
