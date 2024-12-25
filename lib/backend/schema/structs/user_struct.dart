// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    bool? isRegistered,
  }) : _isRegistered = isRegistered;

  // "isRegistered" field.
  bool? _isRegistered;
  bool get isRegistered => _isRegistered ?? false;
  set isRegistered(bool? val) => _isRegistered = val;

  bool hasIsRegistered() => _isRegistered != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        isRegistered: data['isRegistered'] as bool?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'isRegistered': _isRegistered,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'isRegistered': serializeParam(
          _isRegistered,
          ParamType.bool,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        isRegistered: deserializeParam(
          data['isRegistered'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct && isRegistered == other.isRegistered;
  }

  @override
  int get hashCode => const ListEquality().hash([isRegistered]);
}

UserStruct createUserStruct({
  bool? isRegistered,
}) =>
    UserStruct(
      isRegistered: isRegistered,
    );
