import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
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

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  MessageTypeStruct _message = MessageTypeStruct.fromSerializableMap(jsonDecode(
      '{\"type\":\"String\",\"role\":\"String\",\"message\":\"List < Data (MessageType) >\",\"ImageData\":\"String\",\"timestamp\":\"1704603600000\"}'));
  MessageTypeStruct get message => _message;
  set message(MessageTypeStruct value) {
    _message = value;
  }

  void updateMessageStruct(Function(MessageTypeStruct) updateFn) {
    updateFn(_message);
  }

  String _token = '';
  String get token => _token;
  set token(String value) {
    _token = value;
  }

  UserStruct _user = UserStruct();
  UserStruct get user => _user;
  set user(UserStruct value) {
    _user = value;
  }

  void updateUserStruct(Function(UserStruct) updateFn) {
    updateFn(_user);
  }

  bool _plantSearchActive = false;
  bool get plantSearchActive => _plantSearchActive;
  set plantSearchActive(bool value) {
    _plantSearchActive = value;
  }

  List<String> _plantNamesForSearch = [];
  List<String> get plantNamesForSearch => _plantNamesForSearch;
  set plantNamesForSearch(List<String> value) {
    _plantNamesForSearch = value;
  }

  void addToPlantNamesForSearch(String value) {
    plantNamesForSearch.add(value);
  }

  void removeFromPlantNamesForSearch(String value) {
    plantNamesForSearch.remove(value);
  }

  void removeAtIndexFromPlantNamesForSearch(int index) {
    plantNamesForSearch.removeAt(index);
  }

  void updatePlantNamesForSearchAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    plantNamesForSearch[index] = updateFn(_plantNamesForSearch[index]);
  }

  void insertAtIndexInPlantNamesForSearch(int index, String value) {
    plantNamesForSearch.insert(index, value);
  }

  bool _isNewNotification = false;
  bool get isNewNotification => _isNewNotification;
  set isNewNotification(bool value) {
    _isNewNotification = value;
  }

  bool _wrongLogin = false;
  bool get wrongLogin => _wrongLogin;
  set wrongLogin(bool value) {
    _wrongLogin = value;
  }

  bool _aiSearchResultDisplay = false;
  bool get aiSearchResultDisplay => _aiSearchResultDisplay;
  set aiSearchResultDisplay(bool value) {
    _aiSearchResultDisplay = value;
  }

  String _firstName = '';
  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
  }

  String _lastName = '';
  String get lastName => _lastName;
  set lastName(String value) {
    _lastName = value;
  }

  String _inspirationTitle = '';
  String get inspirationTitle => _inspirationTitle;
  set inspirationTitle(String value) {
    _inspirationTitle = value;
  }

  String _inspirationBody = '';
  String get inspirationBody => _inspirationBody;
  set inspirationBody(String value) {
    _inspirationBody = value;
  }

  bool _profileIsSet = false;
  bool get profileIsSet => _profileIsSet;
  set profileIsSet(bool value) {
    _profileIsSet = value;
  }

  String _customError = '';
  String get customError => _customError;
  set customError(String value) {
    _customError = value;
  }

  bool _isTowerActive = false;
  bool get isTowerActive => _isTowerActive;
  set isTowerActive(bool value) {
    _isTowerActive = value;
  }

  int _farmSpacerCapacity = 0;
  int get farmSpacerCapacity => _farmSpacerCapacity;
  set farmSpacerCapacity(int value) {
    _farmSpacerCapacity = value;
  }

  double _ecValue = 0.0;
  double get ecValue => _ecValue;
  set ecValue(double value) {
    _ecValue = value;
  }
}
