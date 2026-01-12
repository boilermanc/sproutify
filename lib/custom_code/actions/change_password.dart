// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!



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
      rethrow;
    }
  } catch (error) {
    print('Outer Error Details: $error');
    FFAppState().update(() {
      FFAppState().customError = 'Error: $error';
    });
    return false;
  }
}
