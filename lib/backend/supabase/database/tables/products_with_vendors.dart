import '../database.dart';

class ProductsWithVendorsTable extends SupabaseTable<ProductsWithVendorsRow> {
  @override
  String get tableName => 'products_with_vendors';

  @override
  ProductsWithVendorsRow createRow(Map<String, dynamic> data) =>
      ProductsWithVendorsRow(data);
}

class ProductsWithVendorsRow extends SupabaseDataRow {
  ProductsWithVendorsRow(super.data);

  @override
  SupabaseTable get table => ProductsWithVendorsTable();

  int? get productid => getField<int>('productid');
  set productid(int? value) => setField<int>('productid', value);

  String? get productname => getField<String>('productname');
  set productname(String? value) => setField<String>('productname', value);

  String? get imageurl => getField<String>('imageurl');
  set imageurl(String? value) => setField<String>('imageurl', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get affiliatelink => getField<String>('affiliatelink');
  set affiliatelink(String? value) => setField<String>('affiliatelink', value);

  int? get vendorid => getField<int>('vendorid');
  set vendorid(int? value) => setField<int>('vendorid', value);

  String? get vendorname => getField<String>('vendorname');
  set vendorname(String? value) => setField<String>('vendorname', value);
}
