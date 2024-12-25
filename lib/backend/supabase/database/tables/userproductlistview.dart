import '../database.dart';

class UserproductlistviewTable extends SupabaseTable<UserproductlistviewRow> {
  @override
  String get tableName => 'userproductlistview';

  @override
  UserproductlistviewRow createRow(Map<String, dynamic> data) =>
      UserproductlistviewRow(data);
}

class UserproductlistviewRow extends SupabaseDataRow {
  UserproductlistviewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserproductlistviewTable();

  int? get userproductid => getField<int>('userproductid');
  set userproductid(int? value) => setField<int>('userproductid', value);

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  int? get productid => getField<int>('productid');
  set productid(int? value) => setField<int>('productid', value);

  String? get productname => getField<String>('productname');
  set productname(String? value) => setField<String>('productname', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get vendorname => getField<String>('vendorname');
  set vendorname(String? value) => setField<String>('vendorname', value);

  int? get userpurchasedquantity => getField<int>('userpurchasedquantity');
  set userpurchasedquantity(int? value) =>
      setField<int>('userpurchasedquantity', value);

  double? get userpurchasecost => getField<double>('userpurchasecost');
  set userpurchasecost(double? value) =>
      setField<double>('userpurchasecost', value);

  DateTime? get userpurchasedate => getField<DateTime>('userpurchasedate');
  set userpurchasedate(DateTime? value) =>
      setField<DateTime>('userpurchasedate', value);

  bool? get archive => getField<bool>('archive');
  set archive(bool? value) => setField<bool>('archive', value);
}
