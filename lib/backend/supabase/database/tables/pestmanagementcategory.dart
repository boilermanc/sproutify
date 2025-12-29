import '../database.dart';

class PestmanagementcategoryTable
    extends SupabaseTable<PestmanagementcategoryRow> {
  @override
  String get tableName => 'pestmanagementcategory';

  @override
  PestmanagementcategoryRow createRow(Map<String, dynamic> data) =>
      PestmanagementcategoryRow(data);
}

class PestmanagementcategoryRow extends SupabaseDataRow {
  PestmanagementcategoryRow(super.data);

  @override
  SupabaseTable get table => PestmanagementcategoryTable();

  int get categoryId => getField<int>('category_id')!;
  set categoryId(int value) => setField<int>('category_id', value);

  String get categoryName => getField<String>('category_name')!;
  set categoryName(String value) => setField<String>('category_name', value);

  String get categoryType => getField<String>('category_type')!;
  set categoryType(String value) => setField<String>('category_type', value);

  String? get categoryImageUrl => getField<String>('category_image_url');
  set categoryImageUrl(String? value) =>
      setField<String>('category_image_url', value);
}
