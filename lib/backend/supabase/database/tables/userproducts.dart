import '../database.dart';

class UserproductsTable extends SupabaseTable<UserproductsRow> {
  @override
  String get tableName => 'userproducts';

  @override
  UserproductsRow createRow(Map<String, dynamic> data) => UserproductsRow(data);
}

class UserproductsRow extends SupabaseDataRow {
  UserproductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserproductsTable();

  int get userproductid => getField<int>('userproductid')!;
  set userproductid(int value) => setField<int>('userproductid', value);

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  int? get productid => getField<int>('productid');
  set productid(int? value) => setField<int>('productid', value);

  DateTime? get userpurchasedate => getField<DateTime>('userpurchasedate');
  set userpurchasedate(DateTime? value) =>
      setField<DateTime>('userpurchasedate', value);

  int? get userpurchasedquantity => getField<int>('userpurchasedquantity');
  set userpurchasedquantity(int? value) =>
      setField<int>('userpurchasedquantity', value);

  double? get userpurchasecost => getField<double>('userpurchasecost');
  set userpurchasecost(double? value) =>
      setField<double>('userpurchasecost', value);
}
