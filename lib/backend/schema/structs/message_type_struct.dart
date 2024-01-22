// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageTypeStruct extends BaseStruct {
  MessageTypeStruct({
    String? type,
    String? role,
    String? message,
    String? imageData,
    DateTime? timestamp,
  })  : _type = type,
        _role = role,
        _message = message,
        _imageData = imageData,
        _timestamp = timestamp;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;
  bool hasType() => _type != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;
  bool hasRole() => _role != null;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  set message(String? val) => _message = val;
  bool hasMessage() => _message != null;

  // "ImageData" field.
  String? _imageData;
  String get imageData => _imageData ?? '';
  set imageData(String? val) => _imageData = val;
  bool hasImageData() => _imageData != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;
  bool hasTimestamp() => _timestamp != null;

  static MessageTypeStruct fromMap(Map<String, dynamic> data) =>
      MessageTypeStruct(
        type: data['type'] as String?,
        role: data['role'] as String?,
        message: data['message'] as String?,
        imageData: data['ImageData'] as String?,
        timestamp: data['timestamp'] as DateTime?,
      );

  static MessageTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? MessageTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
        'role': _role,
        'message': _message,
        'ImageData': _imageData,
        'timestamp': _timestamp,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'message': serializeParam(
          _message,
          ParamType.String,
        ),
        'ImageData': serializeParam(
          _imageData,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static MessageTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageTypeStruct(
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        message: deserializeParam(
          data['message'],
          ParamType.String,
          false,
        ),
        imageData: deserializeParam(
          data['ImageData'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'MessageTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageTypeStruct &&
        type == other.type &&
        role == other.role &&
        message == other.message &&
        imageData == other.imageData &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([type, role, message, imageData, timestamp]);
}

MessageTypeStruct createMessageTypeStruct({
  String? type,
  String? role,
  String? message,
  String? imageData,
  DateTime? timestamp,
}) =>
    MessageTypeStruct(
      type: type,
      role: role,
      message: message,
      imageData: imageData,
      timestamp: timestamp,
    );
