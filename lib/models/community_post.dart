// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunityPost extends BaseStruct {
  CommunityPost({
    String? id,
    String? userId,
    String? photoUrl,
    double? photoAspectRatio,
    String? caption,
    int? towerId,
    String? locationCity,
    String? locationState,
    bool? isFeatured,
    String? featuredType,
    bool? isApproved,
    bool? isHidden,
    int? viewCount,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? reportsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _id = id,
        _userId = userId,
        _photoUrl = photoUrl,
        _photoAspectRatio = photoAspectRatio,
        _caption = caption,
        _towerId = towerId,
        _locationCity = locationCity,
        _locationState = locationState,
        _isFeatured = isFeatured,
        _featuredType = featuredType,
        _isApproved = isApproved,
        _isHidden = isHidden,
        _viewCount = viewCount,
        _likesCount = likesCount,
        _commentsCount = commentsCount,
        _sharesCount = sharesCount,
        _reportsCount = reportsCount,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

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

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  set photoUrl(String? val) => _photoUrl = val;
  bool hasPhotoUrl() => _photoUrl != null;

  // "photo_aspect_ratio" field.
  double? _photoAspectRatio;
  double get photoAspectRatio => _photoAspectRatio ?? 1.0;
  set photoAspectRatio(double? val) => _photoAspectRatio = val;
  bool hasPhotoAspectRatio() => _photoAspectRatio != null;

  // "caption" field.
  String? _caption;
  String get caption => _caption ?? '';
  set caption(String? val) => _caption = val;
  bool hasCaption() => _caption != null;

  // "tower_id" field.
  int? _towerId;
  int? get towerId => _towerId;
  set towerId(int? val) => _towerId = val;
  bool hasTowerId() => _towerId != null;

  // "location_city" field.
  String? _locationCity;
  String get locationCity => _locationCity ?? '';
  set locationCity(String? val) => _locationCity = val;
  bool hasLocationCity() => _locationCity != null;

  // "location_state" field.
  String? _locationState;
  String get locationState => _locationState ?? '';
  set locationState(String? val) => _locationState = val;
  bool hasLocationState() => _locationState != null;

  // "is_featured" field.
  bool? _isFeatured;
  bool get isFeatured => _isFeatured ?? false;
  set isFeatured(bool? val) => _isFeatured = val;
  bool hasIsFeatured() => _isFeatured != null;

  // "featured_type" field.
  String? _featuredType;
  String get featuredType => _featuredType ?? '';
  set featuredType(String? val) => _featuredType = val;
  bool hasFeaturedType() => _featuredType != null;

  // "is_approved" field.
  bool? _isApproved;
  bool get isApproved => _isApproved ?? true;
  set isApproved(bool? val) => _isApproved = val;
  bool hasIsApproved() => _isApproved != null;

  // "is_hidden" field.
  bool? _isHidden;
  bool get isHidden => _isHidden ?? false;
  set isHidden(bool? val) => _isHidden = val;
  bool hasIsHidden() => _isHidden != null;

  // "view_count" field.
  int? _viewCount;
  int get viewCount => _viewCount ?? 0;
  set viewCount(int? val) => _viewCount = val;
  bool hasViewCount() => _viewCount != null;

  // "likes_count" field.
  int? _likesCount;
  int get likesCount => _likesCount ?? 0;
  set likesCount(int? val) => _likesCount = val;
  bool hasLikesCount() => _likesCount != null;

  // "comments_count" field.
  int? _commentsCount;
  int get commentsCount => _commentsCount ?? 0;
  set commentsCount(int? val) => _commentsCount = val;
  bool hasCommentsCount() => _commentsCount != null;

  // "shares_count" field.
  int? _sharesCount;
  int get sharesCount => _sharesCount ?? 0;
  set sharesCount(int? val) => _sharesCount = val;
  bool hasSharesCount() => _sharesCount != null;

  // "reports_count" field.
  int? _reportsCount;
  int get reportsCount => _reportsCount ?? 0;
  set reportsCount(int? val) => _reportsCount = val;
  bool hasReportsCount() => _reportsCount != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;
  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;
  bool hasUpdatedAt() => _updatedAt != null;

  static CommunityPost fromMap(Map<String, dynamic> data) => CommunityPost(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        photoUrl: data['photo_url'] as String?,
        photoAspectRatio: (data['photo_aspect_ratio'] as num?)?.toDouble(),
        caption: data['caption'] as String?,
        towerId: data['tower_id'] as int?,
        locationCity: data['location_city'] as String?,
        locationState: data['location_state'] as String?,
        isFeatured: data['is_featured'] as bool?,
        featuredType: data['featured_type'] as String?,
        isApproved: data['is_approved'] as bool?,
        isHidden: data['is_hidden'] as bool?,
        viewCount: data['view_count'] as int?,
        likesCount: data['likes_count'] as int?,
        commentsCount: data['comments_count'] as int?,
        sharesCount: data['shares_count'] as int?,
        reportsCount: data['reports_count'] as int?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
      );

  static CommunityPost? maybeFromMap(dynamic data) =>
      data is Map ? CommunityPost.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'user_id': _userId,
        'photo_url': _photoUrl,
        'photo_aspect_ratio': _photoAspectRatio,
        'caption': _caption,
        'tower_id': _towerId,
        'location_city': _locationCity,
        'location_state': _locationState,
        'is_featured': _isFeatured,
        'featured_type': _featuredType,
        'is_approved': _isApproved,
        'is_hidden': _isHidden,
        'view_count': _viewCount,
        'likes_count': _likesCount,
        'comments_count': _commentsCount,
        'shares_count': _sharesCount,
        'reports_count': _reportsCount,
        'created_at': _createdAt?.toIso8601String(),
        'updated_at': _updatedAt?.toIso8601String(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(_id, ParamType.String),
        'user_id': serializeParam(_userId, ParamType.String),
        'photo_url': serializeParam(_photoUrl, ParamType.String),
        'photo_aspect_ratio': serializeParam(_photoAspectRatio, ParamType.double),
        'caption': serializeParam(_caption, ParamType.String),
        'tower_id': serializeParam(_towerId, ParamType.int),
        'location_city': serializeParam(_locationCity, ParamType.String),
        'location_state': serializeParam(_locationState, ParamType.String),
        'is_featured': serializeParam(_isFeatured, ParamType.bool),
        'featured_type': serializeParam(_featuredType, ParamType.String),
        'is_approved': serializeParam(_isApproved, ParamType.bool),
        'is_hidden': serializeParam(_isHidden, ParamType.bool),
        'view_count': serializeParam(_viewCount, ParamType.int),
        'likes_count': serializeParam(_likesCount, ParamType.int),
        'comments_count': serializeParam(_commentsCount, ParamType.int),
        'shares_count': serializeParam(_sharesCount, ParamType.int),
        'reports_count': serializeParam(_reportsCount, ParamType.int),
        'created_at': serializeParam(_createdAt, ParamType.DateTime),
        'updated_at': serializeParam(_updatedAt, ParamType.DateTime),
      }.withoutNulls;

  static CommunityPost fromSerializableMap(Map<String, dynamic> data) =>
      CommunityPost(
        id: deserializeParam(data['id'], ParamType.String, false),
        userId: deserializeParam(data['user_id'], ParamType.String, false),
        photoUrl: deserializeParam(data['photo_url'], ParamType.String, false),
        photoAspectRatio:
            deserializeParam(data['photo_aspect_ratio'], ParamType.double, false),
        caption: deserializeParam(data['caption'], ParamType.String, false),
        towerId: deserializeParam(data['tower_id'], ParamType.int, false),
        locationCity:
            deserializeParam(data['location_city'], ParamType.String, false),
        locationState:
            deserializeParam(data['location_state'], ParamType.String, false),
        isFeatured: deserializeParam(data['is_featured'], ParamType.bool, false),
        featuredType:
            deserializeParam(data['featured_type'], ParamType.String, false),
        isApproved: deserializeParam(data['is_approved'], ParamType.bool, false),
        isHidden: deserializeParam(data['is_hidden'], ParamType.bool, false),
        viewCount: deserializeParam(data['view_count'], ParamType.int, false),
        likesCount: deserializeParam(data['likes_count'], ParamType.int, false),
        commentsCount:
            deserializeParam(data['comments_count'], ParamType.int, false),
        sharesCount:
            deserializeParam(data['shares_count'], ParamType.int, false),
        reportsCount:
            deserializeParam(data['reports_count'], ParamType.int, false),
        createdAt:
            deserializeParam(data['created_at'], ParamType.DateTime, false),
        updatedAt:
            deserializeParam(data['updated_at'], ParamType.DateTime, false),
      );

  @override
  String toString() => 'CommunityPost(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CommunityPost && id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([id]);
}

CommunityPost createCommunityPost({
  String? id,
  String? userId,
  String? photoUrl,
  double? photoAspectRatio,
  String? caption,
  int? towerId,
  String? locationCity,
  String? locationState,
  bool? isFeatured,
  String? featuredType,
  bool? isApproved,
  bool? isHidden,
  int? viewCount,
  int? likesCount,
  int? commentsCount,
  int? sharesCount,
  int? reportsCount,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    CommunityPost(
      id: id,
      userId: userId,
      photoUrl: photoUrl,
      photoAspectRatio: photoAspectRatio,
      caption: caption,
      towerId: towerId,
      locationCity: locationCity,
      locationState: locationState,
      isFeatured: isFeatured,
      featuredType: featuredType,
      isApproved: isApproved,
      isHidden: isHidden,
      viewCount: viewCount,
      likesCount: likesCount,
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      reportsCount: reportsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

