import '../database.dart';

class EcValuesTable extends SupabaseTable<EcValuesRow> {
  @override
  String get tableName => 'ec_values';

  @override
  EcValuesRow createRow(Map<String, dynamic> data) => EcValuesRow(data);
}

class EcValuesRow extends SupabaseDataRow {
  EcValuesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EcValuesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  double get ecValue => getField<double>('ec_value')!;
  set ecValue(double value) => setField<double>('ec_value', value);

  String? get ecImageUrl => getField<String>('ec_image_url');
  set ecImageUrl(String? value) => setField<String>('ec_image_url', value);

  String? get ecReview => getField<String>('ec_review');
  set ecReview(String? value) => setField<String>('ec_review', value);

  String? get ecReviewImageUrl => getField<String>('ec_review_image_url');
  set ecReviewImageUrl(String? value) =>
      setField<String>('ec_review_image_url', value);
}
