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

Future<bool> updateSupabasePassword(String newPassword) async {
  // Add your function code here!
  try {
    final response = await SupaFlow.client.auth
        .updateUser(UserAttributes(password: newPassword));

    if (response.user != null) {
      return true; // Password updated successfully
    } else {
      return false; // Failed to update password
    }
  } catch (e) {
    print('Error updating password: $e');
    return false; // Return false if an exception occurs
  }
}
