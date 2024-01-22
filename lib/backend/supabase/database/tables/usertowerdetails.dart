import '../database.dart';

class UsertowerdetailsTable extends SupabaseTable<UsertowerdetailsRow> {
  @override
  String get tableName => 'usertowerdetails';

  @override
  UsertowerdetailsRow createRow(Map<String, dynamic> data) =>
      UsertowerdetailsRow(data);
}

class UsertowerdetailsRow extends SupabaseDataRow {
  UsertowerdetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsertowerdetailsTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);

  int? get towerId => getField<int>('tower_id');
  set towerId(int? value) => setField<int>('tower_id', value);

  String? get towerName => getField<String>('tower_name');
  set towerName(String? value) => setField<String>('tower_name', value);

  String? get towerType => getField<String>('tower_type');
  set towerType(String? value) => setField<String>('tower_type', value);

  double? get ports => getField<double>('ports');
  set ports(double? value) => setField<double>('ports', value);

  String? get indoorOutdoor => getField<String>('indoor_outdoor');
  set indoorOutdoor(String? value) => setField<String>('indoor_outdoor', value);

  String? get tgCorpImage => getField<String>('tg_corp_image');
  set tgCorpImage(String? value) => setField<String>('tg_corp_image', value);

  double? get latestPhValue => getField<double>('latest_ph_value');
  set latestPhValue(double? value) =>
      setField<double>('latest_ph_value', value);

  String? get phImageUrl => getField<String>('ph_image_url');
  set phImageUrl(String? value) => setField<String>('ph_image_url', value);

  String? get phReview => getField<String>('ph_review');
  set phReview(String? value) => setField<String>('ph_review', value);

  String? get reviewImageUrl => getField<String>('review_image_url');
  set reviewImageUrl(String? value) =>
      setField<String>('review_image_url', value);

  double? get latestEcValue => getField<double>('latest_ec_value');
  set latestEcValue(double? value) =>
      setField<double>('latest_ec_value', value);

  String? get ecImageUrl => getField<String>('ec_image_url');
  set ecImageUrl(String? value) => setField<String>('ec_image_url', value);

  String? get ecReview => getField<String>('ec_review');
  set ecReview(String? value) => setField<String>('ec_review', value);

  String? get ecReviewImageUrl => getField<String>('ec_review_image_url');
  set ecReviewImageUrl(String? value) =>
      setField<String>('ec_review_image_url', value);
}
