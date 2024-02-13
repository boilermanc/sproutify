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

  bool _isplantFavorite = false;
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

  UserStruct _user = UserStruct();
  UserStruct get user => _user;
  set user(UserStruct _value) {
    _user = _value;
  }

  void updateUserStruct(Function(UserStruct) updateFn) {
    updateFn(_user);
  }

  bool _plantSearchActive = false;
  bool get plantSearchActive => _plantSearchActive;
  set plantSearchActive(bool _value) {
    _plantSearchActive = _value;
  }

  bool _hasNewNotifications = false;
  bool get hasNewNotifications => _hasNewNotifications;
  set hasNewNotifications(bool _value) {
    _hasNewNotifications = _value;
  }

  List<String> _plantNamesForSearch = [];
  List<String> get plantNamesForSearch => _plantNamesForSearch;
  set plantNamesForSearch(List<String> _value) {
    _plantNamesForSearch = _value;
  }

  void addToPlantNamesForSearch(String _value) {
    _plantNamesForSearch.add(_value);
  }

  void removeFromPlantNamesForSearch(String _value) {
    _plantNamesForSearch.remove(_value);
  }

  void removeAtIndexFromPlantNamesForSearch(int _index) {
    _plantNamesForSearch.removeAt(_index);
  }

  void updatePlantNamesForSearchAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _plantNamesForSearch[_index] = updateFn(_plantNamesForSearch[_index]);
  }

  void insertAtIndexInPlantNamesForSearch(int _index, String _value) {
    _plantNamesForSearch.insert(_index, _value);
  }
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
