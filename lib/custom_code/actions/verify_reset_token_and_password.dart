// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
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
