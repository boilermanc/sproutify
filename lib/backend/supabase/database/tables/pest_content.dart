import '../database.dart';

class PestContentTable extends SupabaseTable<PestContentRow> {
  @override
  String get tableName => 'pest_content';

  @override
  PestContentRow createRow(Map<String, dynamic> data) => PestContentRow(data);
}

class PestContentRow extends SupabaseDataRow {
  PestContentRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PestContentTable();

  int get contentId => getField<int>('content_id')!;
  set contentId(int value) => setField<int>('content_id', value);

  int? get categoryId => getField<int>('category_id');
  set categoryId(int? value) => setField<int>('category_id', value);

  String get contentTitle => getField<String>('content_title')!;
  set contentTitle(String value) => setField<String>('content_title', value);

  String get contentBody => getField<String>('content_body')!;
  set contentBody(String value) => setField<String>('content_body', value);

  String? get contentImageUrl => getField<String>('content_image_url');
  set contentImageUrl(String? value) =>
      setField<String>('content_image_url', value);

  String? get contentResourceUrl => getField<String>('content_resource_url');
  set contentResourceUrl(String? value) =>
      setField<String>('content_resource_url', value);
}
