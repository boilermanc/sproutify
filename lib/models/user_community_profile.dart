// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserCommunityProfile extends BaseStruct {
  UserCommunityProfile({
    String? userId,
    String? bio,
    String? profilePhotoUrl,
    bool? isPublic,
    bool? showLocation,
    bool? showStats,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    int? totalLikesReceived,
    DateTime? joinedCommunityAt,
    DateTime? updatedAt,
  })  : _userId = userId,
        _bio = bio,
        _profilePhotoUrl = profilePhotoUrl,
        _isPublic = isPublic,
        _showLocation = showLocation,
        _showStats = showStats,
        _postsCount = postsCount,
        _followersCount = followersCount,
        _followingCount = followingCount,
        _totalLikesReceived = totalLikesReceived,
        _joinedCommunityAt = joinedCommunityAt,
        _updatedAt = updatedAt;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;
  bool hasUserId() => _userId != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  set bio(String? val) => _bio = val;
  bool hasBio() => _bio != null;

  // "profile_photo_url" field.
  String? _profilePhotoUrl;
  String get profilePhotoUrl => _profilePhotoUrl ?? '';
  set profilePhotoUrl(String? val) => _profilePhotoUrl = val;
  bool hasProfilePhotoUrl() => _profilePhotoUrl != null;

  // "is_public" field.
  bool? _isPublic;
  bool get isPublic => _isPublic ?? true;
  set isPublic(bool? val) => _isPublic = val;
  bool hasIsPublic() => _isPublic != null;

  // "show_location" field.
  bool? _showLocation;
  bool get showLocation => _showLocation ?? true;
  set showLocation(bool? val) => _showLocation = val;
  bool hasShowLocation() => _showLocation != null;

  // "show_stats" field.
  bool? _showStats;
  bool get showStats => _showStats ?? true;
  set showStats(bool? val) => _showStats = val;
  bool hasShowStats() => _showStats != null;

  // "posts_count" field.
  int? _postsCount;
  int get postsCount => _postsCount ?? 0;
  set postsCount(int? val) => _postsCount = val;
  bool hasPostsCount() => _postsCount != null;

  // "followers_count" field.
  int? _followersCount;
  int get followersCount => _followersCount ?? 0;
  set followersCount(int? val) => _followersCount = val;
  bool hasFollowersCount() => _followersCount != null;

  // "following_count" field.
  int? _followingCount;
  int get followingCount => _followingCount ?? 0;
  set followingCount(int? val) => _followingCount = val;
  bool hasFollowingCount() => _followingCount != null;

  // "total_likes_received" field.
  int? _totalLikesReceived;
  int get totalLikesReceived => _totalLikesReceived ?? 0;
  set totalLikesReceived(int? val) => _totalLikesReceived = val;
  bool hasTotalLikesReceived() => _totalLikesReceived != null;

  // "joined_community_at" field.
  DateTime? _joinedCommunityAt;
  DateTime? get joinedCommunityAt => _joinedCommunityAt;
  set joinedCommunityAt(DateTime? val) => _joinedCommunityAt = val;
  bool hasJoinedCommunityAt() => _joinedCommunityAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;
  bool hasUpdatedAt() => _updatedAt != null;

  static UserCommunityProfile fromMap(Map<String, dynamic> data) =>
      UserCommunityProfile(
        userId: data['user_id'] as String?,
        bio: data['bio'] as String?,
        profilePhotoUrl: data['profile_photo_url'] as String?,
        isPublic: data['is_public'] as bool?,
        showLocation: data['show_location'] as bool?,
        showStats: data['show_stats'] as bool?,
        postsCount: data['posts_count'] as int?,
        followersCount: data['followers_count'] as int?,
        followingCount: data['following_count'] as int?,
        totalLikesReceived: data['total_likes_received'] as int?,
        joinedCommunityAt: data['joined_community_at'] == null
            ? null
            : DateTime.parse(data['joined_community_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
      );

  static UserCommunityProfile? maybeFromMap(dynamic data) => data is Map
      ? UserCommunityProfile.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'user_id': _userId,
        'bio': _bio,
        'profile_photo_url': _profilePhotoUrl,
        'is_public': _isPublic,
        'show_location': _showLocation,
        'show_stats': _showStats,
        'posts_count': _postsCount,
        'followers_count': _followersCount,
        'following_count': _followingCount,
        'total_likes_received': _totalLikesReceived,
        'joined_community_at': _joinedCommunityAt?.toIso8601String(),
        'updated_at': _updatedAt?.toIso8601String(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_id': serializeParam(_userId, ParamType.String),
        'bio': serializeParam(_bio, ParamType.String),
        'profile_photo_url': serializeParam(_profilePhotoUrl, ParamType.String),
        'is_public': serializeParam(_isPublic, ParamType.bool),
        'show_location': serializeParam(_showLocation, ParamType.bool),
        'show_stats': serializeParam(_showStats, ParamType.bool),
        'posts_count': serializeParam(_postsCount, ParamType.int),
        'followers_count': serializeParam(_followersCount, ParamType.int),
        'following_count': serializeParam(_followingCount, ParamType.int),
        'total_likes_received':
            serializeParam(_totalLikesReceived, ParamType.int),
        'joined_community_at':
            serializeParam(_joinedCommunityAt, ParamType.DateTime),
        'updated_at': serializeParam(_updatedAt, ParamType.DateTime),
      }.withoutNulls;

  static UserCommunityProfile fromSerializableMap(Map<String, dynamic> data) =>
      UserCommunityProfile(
        userId: deserializeParam(data['user_id'], ParamType.String, false),
        bio: deserializeParam(data['bio'], ParamType.String, false),
        profilePhotoUrl:
            deserializeParam(data['profile_photo_url'], ParamType.String, false),
        isPublic: deserializeParam(data['is_public'], ParamType.bool, false),
        showLocation:
            deserializeParam(data['show_location'], ParamType.bool, false),
        showStats: deserializeParam(data['show_stats'], ParamType.bool, false),
        postsCount: deserializeParam(data['posts_count'], ParamType.int, false),
        followersCount:
            deserializeParam(data['followers_count'], ParamType.int, false),
        followingCount:
            deserializeParam(data['following_count'], ParamType.int, false),
        totalLikesReceived:
            deserializeParam(data['total_likes_received'], ParamType.int, false),
        joinedCommunityAt: deserializeParam(
            data['joined_community_at'], ParamType.DateTime, false),
        updatedAt:
            deserializeParam(data['updated_at'], ParamType.DateTime, false),
      );

  @override
  String toString() => 'UserCommunityProfile(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserCommunityProfile && userId == other.userId;
  }

  @override
  int get hashCode => const ListEquality().hash([userId]);
}

UserCommunityProfile createUserCommunityProfile({
  String? userId,
  String? bio,
  String? profilePhotoUrl,
  bool? isPublic,
  bool? showLocation,
  bool? showStats,
  int? postsCount,
  int? followersCount,
  int? followingCount,
  int? totalLikesReceived,
  DateTime? joinedCommunityAt,
  DateTime? updatedAt,
}) =>
    UserCommunityProfile(
      userId: userId,
      bio: bio,
      profilePhotoUrl: profilePhotoUrl,
      isPublic: isPublic,
      showLocation: showLocation,
      showStats: showStats,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
      totalLikesReceived: totalLikesReceived,
      joinedCommunityAt: joinedCommunityAt,
      updatedAt: updatedAt,
    );

