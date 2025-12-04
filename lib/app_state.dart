import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
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
    final prefs = await SharedPreferences.getInstance();

    // Load persisted state
    _firstName = prefs.getString('firstName') ?? '';
    _lastName = prefs.getString('lastName') ?? '';
    _inspirationTitle = prefs.getString('inspirationTitle') ?? '';
    _inspirationBody = prefs.getString('inspirationBody') ?? '';
    _profileIsSet = prefs.getBool('profileIsSet') ?? false;
    _isTowerActive = prefs.getBool('isTowerActive') ?? false;
    _plantSearchActive = prefs.getBool('plantSearchActive') ?? false;
    _isNewNotification = prefs.getBool('isNewNotification') ?? false;
    _wrongLogin = prefs.getBool('wrongLogin') ?? false;
    _aiSearchResultDisplay = prefs.getBool('aiSearchResultDisplay') ?? false;
    _isTowerActive = prefs.getBool('isTowerActive') ?? false;
    _hasSeenTrialTimeline = prefs.getBool('hasSeenTrialTimeline') ?? false;

    // Load plant names list
    final plantNamesJson = prefs.getString('plantNamesForSearch');
    if (plantNamesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(plantNamesJson);
        _plantNamesForSearch = decoded.cast<String>();
      } catch (e) {
        _plantNamesForSearch = [];
      }
    }

    // Load user struct if available
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        _user = UserStruct.fromSerializableMap(jsonDecode(userJson));
      } catch (e) {
        _user = UserStruct();
      }
    }
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
    _persistState();
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();

    // Persist all state variables
    await prefs.setString('firstName', _firstName);
    await prefs.setString('lastName', _lastName);
    await prefs.setString('inspirationTitle', _inspirationTitle);
    await prefs.setString('inspirationBody', _inspirationBody);
    await prefs.setBool('profileIsSet', _profileIsSet);
    await prefs.setBool('isTowerActive', _isTowerActive);
    await prefs.setBool('plantSearchActive', _plantSearchActive);
    await prefs.setBool('isNewNotification', _isNewNotification);
    await prefs.setBool('wrongLogin', _wrongLogin);
    await prefs.setBool('aiSearchResultDisplay', _aiSearchResultDisplay);
    await prefs.setBool('hasSeenTrialTimeline', _hasSeenTrialTimeline);

    // Persist plant names list
    await prefs.setString(
        'plantNamesForSearch', jsonEncode(_plantNamesForSearch));

    // Persist user struct
    await prefs.setString('user', jsonEncode(_user.toSerializableMap()));
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

  bool _hasSeenTrialTimeline = false;
  bool get hasSeenTrialTimeline => _hasSeenTrialTimeline;
  set hasSeenTrialTimeline(bool value) {
    _hasSeenTrialTimeline = value;
  }
}
