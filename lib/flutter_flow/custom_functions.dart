import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String? returnDateYYYYMMDD() {
  // function to return the date in a format of YYYY-MM-DD
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return formattedDate;
}

bool? showPlantSearchResults(
  String textSearchFor,
  String textSearchIn,
) {
  return textSearchIn.toLowerCase().contains(textSearchFor.toLowerCase());
}

bool? checkIsNewStatus(String jsonNotifications) {
  if (jsonNotifications == null) {
    // Handle the case where jsonNotifications is null if necessary
    return false;
  }

  // Parse the non-null JSON string into a list of maps
  // ignore: unused_local_variable
  List<dynamic> notificationsList = jsonDecode(jsonNotifications);

  // Iterate over each notification to check if 'is_new' is true
  for (final Map<String, dynamic> notification in notificationsList) {
    if (notification['is_new'] == true) {
      return true; // Return true if any notification is new
    }
  }

  return false; // Return false if no new notifications are found
}

String displayDateAsUTC() {
  // force a date to display in utc format only year, month, day
  final now = DateTime.now().toUtc();
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(now);
}

dynamic saveChatHistory(
  dynamic chatHistory,
  dynamic newChat,
) {
  // If chatHistory isn't a list, make it a list and then add newChat
  if (chatHistory is List) {
    chatHistory.add(newChat);
    return chatHistory;
  } else {
    return [newChat];
  }
}

dynamic convertToJSON(String prompt) {
  // take the prompt and return a JSON with form [{"role": "user", "content": prompt}]
  return json.decode('{"role": "user", "content": "$prompt"}');
}
