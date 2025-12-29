// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
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
