import '../database.dart';

class ProductsSubcategoriesTable
    extends SupabaseTable<ProductsSubcategoriesRow> {
  @override
  String get tableName => 'products_subcategories';

  @override
  ProductsSubcategoriesRow createRow(Map<String, dynamic> data) =>
      ProductsSubcategoriesRow(data);
}

class ProductsSubcategoriesRow extends SupabaseDataRow {
  ProductsSubcategoriesRow(super.data);

  @override
  SupabaseTable get table => ProductsSubcategoriesTable();

  int get subcategoryid => getField<int>('subcategoryid')!;
  set subcategoryid(int value) => setField<int>('subcategoryid', value);

  String get subcategoryname => getField<String>('subcategoryname')!;
  set subcategoryname(String value) =>
      setField<String>('subcategoryname', value);

  int? get categoryid => getField<int>('categoryid');
  set categoryid(int? value) => setField<int>('categoryid', value);
}
