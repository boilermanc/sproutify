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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:supabase/supabase.dart';

Future<bool> changePassword(String? newPassword) async {
  try {
    // Get the token from the URL and log it
    final uri = Uri.parse(Uri.base.toString());
    final token = uri.queryParameters['token'];
    final type = uri.queryParameters['type'];

    print('URL Parameters:');
    print('Token: $token');
    print('Type: $type');
    print('New Password: ${newPassword?.length ?? 0} characters');

    if (token == null || token.isEmpty) {
      print('Error: Token is missing');
      throw Exception('Reset token is missing');
    }

    try {
      print('Attempting to verify OTP...');
      final verifyResponse = await SupaFlow.client.auth.verifyOTP(
        token: token,
        type: OtpType.recovery,
      );
      print(
          'Verify Response: ${verifyResponse.session != null ? 'Session created' : 'No session'}');

      if (verifyResponse.session != null) {
        print('Attempting to update password...');
        final updateResponse = await SupaFlow.client.auth.updateUser(
          UserAttributes(
            password: newPassword,
          ),
        );
        print(
            'Update Response: ${updateResponse.user != null ? 'Success' : 'Failed'}');
        return updateResponse.user != null;
      } else {
        print('Error: Session not created after verification');
        return false;
      }
    } catch (innerError) {
      print('Inner Error Details: $innerError');
      throw innerError;
    }
  } catch (error) {
    print('Outer Error Details: $error');
    FFAppState().update(() {
      FFAppState().customError = 'Error: $error';
    });
    return false;
  }
}
