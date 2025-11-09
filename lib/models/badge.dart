// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Badge extends BaseStruct {
  Badge({
    String? id,
    String? name,
    String? description,
    String? category,
    String? iconUrl,
    String? tier,
    String? rarity,
    int? xpValue,
    String? triggerType,
    int? triggerThreshold,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
  })  : _id = id,
        _name = name,
        _description = description,
        _category = category,
        _iconUrl = iconUrl,
        _tier = tier,
        _rarity = rarity,
        _xpValue = xpValue,
        _triggerType = triggerType,
        _triggerThreshold = triggerThreshold,
        _isActive = isActive,
        _sortOrder = sortOrder,
        _createdAt = createdAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;
  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;
  bool hasDescription() => _description != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;
  bool hasCategory() => _category != null;

  // "icon_url" field.
  String? _iconUrl;
  String get iconUrl => _iconUrl ?? '';
  set iconUrl(String? val) => _iconUrl = val;
  bool hasIconUrl() => _iconUrl != null;

  // "tier" field.
  String? _tier;
  String get tier => _tier ?? '';
  set tier(String? val) => _tier = val;
  bool hasTier() => _tier != null;

  // "rarity" field.
  String? _rarity;
  String get rarity => _rarity ?? '';
  set rarity(String? val) => _rarity = val;
  bool hasRarity() => _rarity != null;

  // "xp_value" field.
  int? _xpValue;
  int get xpValue => _xpValue ?? 100;
  set xpValue(int? val) => _xpValue = val;
  bool hasXpValue() => _xpValue != null;

  // "trigger_type" field.
  String? _triggerType;
  String get triggerType => _triggerType ?? '';
  set triggerType(String? val) => _triggerType = val;
  bool hasTriggerType() => _triggerType != null;

  // "trigger_threshold" field.
  int? _triggerThreshold;
  int? get triggerThreshold => _triggerThreshold;
  set triggerThreshold(int? val) => _triggerThreshold = val;
  bool hasTriggerThreshold() => _triggerThreshold != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? true;
  set isActive(bool? val) => _isActive = val;
  bool hasIsActive() => _isActive != null;

  // "sort_order" field.
  int? _sortOrder;
  int get sortOrder => _sortOrder ?? 0;
  set sortOrder(int? val) => _sortOrder = val;
  bool hasSortOrder() => _sortOrder != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;
  bool hasCreatedAt() => _createdAt != null;

  static Badge fromMap(Map<String, dynamic> data) => Badge(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        tier: data['tier'] as String?,
        rarity: data['rarity'] as String?,
        xpValue: data['xp_value'] as int?,
        triggerType: data['trigger_type'] as String?,
        triggerThreshold: data['trigger_threshold'] as int?,
        isActive: data['is_active'] as bool?,
        sortOrder: data['sort_order'] as int?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
      );

  static Badge? maybeFromMap(dynamic data) =>
      data is Map ? Badge.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'description': _description,
        'category': _category,
        'icon_url': _iconUrl,
        'tier': _tier,
        'rarity': _rarity,
        'xp_value': _xpValue,
        'trigger_type': _triggerType,
        'trigger_threshold': _triggerThreshold,
        'is_active': _isActive,
        'sort_order': _sortOrder,
        'created_at': _createdAt?.toIso8601String(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(_id, ParamType.String),
        'name': serializeParam(_name, ParamType.String),
        'description': serializeParam(_description, ParamType.String),
        'category': serializeParam(_category, ParamType.String),
        'icon_url': serializeParam(_iconUrl, ParamType.String),
        'tier': serializeParam(_tier, ParamType.String),
        'rarity': serializeParam(_rarity, ParamType.String),
        'xp_value': serializeParam(_xpValue, ParamType.int),
        'trigger_type': serializeParam(_triggerType, ParamType.String),
        'trigger_threshold': serializeParam(_triggerThreshold, ParamType.int),
        'is_active': serializeParam(_isActive, ParamType.bool),
        'sort_order': serializeParam(_sortOrder, ParamType.int),
        'created_at': serializeParam(_createdAt, ParamType.DateTime),
      }.withoutNulls;

  static Badge fromSerializableMap(Map<String, dynamic> data) => Badge(
        id: deserializeParam(data['id'], ParamType.String, false),
        name: deserializeParam(data['name'], ParamType.String, false),
        description:
            deserializeParam(data['description'], ParamType.String, false),
        category: deserializeParam(data['category'], ParamType.String, false),
        iconUrl: deserializeParam(data['icon_url'], ParamType.String, false),
        tier: deserializeParam(data['tier'], ParamType.String, false),
        rarity: deserializeParam(data['rarity'], ParamType.String, false),
        xpValue: deserializeParam(data['xp_value'], ParamType.int, false),
        triggerType:
            deserializeParam(data['trigger_type'], ParamType.String, false),
        triggerThreshold:
            deserializeParam(data['trigger_threshold'], ParamType.int, false),
        isActive: deserializeParam(data['is_active'], ParamType.bool, false),
        sortOrder: deserializeParam(data['sort_order'], ParamType.int, false),
        createdAt:
            deserializeParam(data['created_at'], ParamType.DateTime, false),
      );

  @override
  String toString() => 'Badge(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is Badge && id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([id]);
}

Badge createBadge({
  String? id,
  String? name,
  String? description,
  String? category,
  String? iconUrl,
  String? tier,
  String? rarity,
  int? xpValue,
  String? triggerType,
  int? triggerThreshold,
  bool? isActive,
  int? sortOrder,
  DateTime? createdAt,
}) =>
    Badge(
      id: id,
      name: name,
      description: description,
      category: category,
      iconUrl: iconUrl,
      tier: tier,
      rarity: rarity,
      xpValue: xpValue,
      triggerType: triggerType,
      triggerThreshold: triggerThreshold,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
    );

