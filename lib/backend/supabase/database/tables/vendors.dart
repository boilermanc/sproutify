import '../database.dart';

class VendorsTable extends SupabaseTable<VendorsRow> {
  @override
  String get tableName => 'vendors';

  @override
  VendorsRow createRow(Map<String, dynamic> data) => VendorsRow(data);
}

class VendorsRow extends SupabaseDataRow {
  VendorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VendorsTable();

  int get vendorid => getField<int>('vendorid')!;
  set vendorid(int value) => setField<int>('vendorid', value);

  String get vendorname => getField<String>('vendorname')!;
  set vendorname(String value) => setField<String>('vendorname', value);

  String? get contactname => getField<String>('contactname');
  set contactname(String? value) => setField<String>('contactname', value);

  String? get contactemail => getField<String>('contactemail');
  set contactemail(String? value) => setField<String>('contactemail', value);

  String? get contactphone => getField<String>('contactphone');
  set contactphone(String? value) => setField<String>('contactphone', value);

  String? get streetaddress => getField<String>('streetaddress');
  set streetaddress(String? value) => setField<String>('streetaddress', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get postalcode => getField<String>('postalcode');
  set postalcode(String? value) => setField<String>('postalcode', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);
}
