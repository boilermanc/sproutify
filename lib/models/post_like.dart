// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostLike extends BaseStruct {
  PostLike({
    String? id,
    String? userId,
    String? postId,
    DateTime? createdAt,
  })  : _id = id,
        _userId = userId,
        _postId = postId,
        _createdAt = createdAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;
  bool hasId() => _id != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;
  bool hasUserId() => _userId != null;

  // "post_id" field.
  String? _postId;
  String get postId => _postId ?? '';
  set postId(String? val) => _postId = val;
  bool hasPostId() => _postId != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;
  bool hasCreatedAt() => _createdAt != null;

  static PostLike fromMap(Map<String, dynamic> data) => PostLike(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        postId: data['post_id'] as String?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
      );

  static PostLike? maybeFromMap(dynamic data) =>
      data is Map ? PostLike.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'user_id': _userId,
        'post_id': _postId,
        'created_at': _createdAt?.toIso8601String(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(_id, ParamType.String),
        'user_id': serializeParam(_userId, ParamType.String),
        'post_id': serializeParam(_postId, ParamType.String),
        'created_at': serializeParam(_createdAt, ParamType.DateTime),
      }.withoutNulls;

  static PostLike fromSerializableMap(Map<String, dynamic> data) => PostLike(
        id: deserializeParam(data['id'], ParamType.String, false),
        userId: deserializeParam(data['user_id'], ParamType.String, false),
        postId: deserializeParam(data['post_id'], ParamType.String, false),
        createdAt:
            deserializeParam(data['created_at'], ParamType.DateTime, false),
      );

  @override
  String toString() => 'PostLike(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PostLike && id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([id]);
}

PostLike createPostLike({
  String? id,
  String? userId,
  String? postId,
  DateTime? createdAt,
}) =>
    PostLike(
      id: id,
      userId: userId,
      postId: postId,
      createdAt: createdAt,
    );

