// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
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
