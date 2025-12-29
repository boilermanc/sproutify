import '../database.dart';

class PhValuesTable extends SupabaseTable<PhValuesRow> {
  @override
  String get tableName => 'ph_values';

  @override
  PhValuesRow createRow(Map<String, dynamic> data) => PhValuesRow(data);
}

class PhValuesRow extends SupabaseDataRow {
  PhValuesRow(super.data);

  @override
  SupabaseTable get table => PhValuesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  double get phValue => getField<double>('ph_value')!;
  set phValue(double value) => setField<double>('ph_value', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get phReview => getField<String>('ph_review');
  set phReview(String? value) => setField<String>('ph_review', value);

  String? get reviewImageUrl => getField<String>('review_image_url');
  set reviewImageUrl(String? value) =>
      setField<String>('review_image_url', value);
}
