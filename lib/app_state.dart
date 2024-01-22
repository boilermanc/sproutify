import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _isplantFavorite =
          prefs.getBool('ff_isplantFavorite') ?? _isplantFavorite;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _isplantFavorite = true;
  bool get isplantFavorite => _isplantFavorite;
  set isplantFavorite(bool _value) {
    _isplantFavorite = _value;
    prefs.setBool('ff_isplantFavorite', _value);
  }

  MessageTypeStruct _message = MessageTypeStruct.fromSerializableMap(jsonDecode(
      '{\"type\":\"String\",\"role\":\"String\",\"message\":\"List < Data (MessageType) >\",\"ImageData\":\"String\",\"timestamp\":\"1704603600000\"}'));
  MessageTypeStruct get message => _message;
  set message(MessageTypeStruct _value) {
    _message = _value;
  }

  void updateMessageStruct(Function(MessageTypeStruct) updateFn) {
    updateFn(_message);
  }

  String _token = '';
  String get token => _token;
  set token(String _value) {
    _token = _value;
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
