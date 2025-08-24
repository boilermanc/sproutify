import '../database.dart';

class ProductsTable extends SupabaseTable<ProductsRow> {
  @override
  String get tableName => 'products';

  @override
  ProductsRow createRow(Map<String, dynamic> data) => ProductsRow(data);
}

class ProductsRow extends SupabaseDataRow {
  ProductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductsTable();

  int get productid => getField<int>('productid')!;
  set productid(int value) => setField<int>('productid', value);

  String get productname => getField<String>('productname')!;
  set productname(String value) => setField<String>('productname', value);

  int? get categoryid => getField<int>('categoryid');
  set categoryid(int? value) => setField<int>('categoryid', value);

  int? get vendorid => getField<int>('vendorid');
  set vendorid(int? value) => setField<int>('vendorid', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  bool? get isactive => getField<bool>('isactive');
  set isactive(bool? value) => setField<bool>('isactive', value);

  String? get imageurl => getField<String>('imageurl');
  set imageurl(String? value) => setField<String>('imageurl', value);

  String? get affiliatelink => getField<String>('affiliatelink');
  set affiliatelink(String? value) => setField<String>('affiliatelink', value);

  String? get directions => getField<String>('directions');
  set directions(String? value) => setField<String>('directions', value);

  int? get subcategoryid => getField<int>('subcategoryid');
  set subcategoryid(int? value) => setField<int>('subcategoryid', value);

  bool? get isvisible => getField<bool>('isvisible');
  set isvisible(bool? value) => setField<bool>('isvisible', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  bool? get tfflag => getField<bool>('tfflag');
  set tfflag(bool? value) => setField<bool>('tfflag', value);
}
