import '../database.dart';

class PlantratingsTable extends SupabaseTable<PlantratingsRow> {
  @override
  String get tableName => 'plantratings';

  @override
  PlantratingsRow createRow(Map<String, dynamic> data) => PlantratingsRow(data);
}

class PlantratingsRow extends SupabaseDataRow {
  PlantratingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlantratingsTable();

  int get ratingnumber => getField<int>('ratingnumber')!;
  set ratingnumber(int value) => setField<int>('ratingnumber', value);

  String get ratingdescription => getField<String>('ratingdescription')!;
  set ratingdescription(String value) =>
      setField<String>('ratingdescription', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);
}
