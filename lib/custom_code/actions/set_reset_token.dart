// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future setResetToken() async {
  // Get token from the URL query parameter
  final Uri uri = Uri.base; // Get current URL
  final String? token = uri.queryParameters['token']; // Extract 'token'

  // Check if the token exists
  if (token != null && token.isNotEmpty) {
    // Save the token into the page state
    FFAppState().token = token; // Update App State
    print('Token set: $token'); // Debugging log
  } else {
    print('No token found in URL'); // Debugging log
  }
}
