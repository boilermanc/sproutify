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

Future<bool> verifyResetTokenAndPassword(
    String token, String newPassword) async {
  try {
    // Use verifyOTP for recovery token validation
    final response = await SupaFlow.client.auth.verifyOTP(
      token: token, // Pass the token received in the email
      type: OtpType.recovery, // Recovery type OTP
    );

    // If the token is verified successfully, update the password
    if (response.session != null) {
      final updateResponse = await SupaFlow.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (updateResponse.user != null) {
        return true; // Password updated successfully
      } else {
        return false; // Failed to update password
      }
    } else {
      return false; // Token verification failed
    }
  } catch (e) {
    print('Error verifying token or updating password: $e');
    return false; // Return false if an error occurs
  }
  // Add your function code here!
}
