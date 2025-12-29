// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!



Future<void> unsubscribe(String table) async {
  final channel = SupaFlow.client.channel('public:$table');

  try {
    await channel.unsubscribe();
  } catch (e) {
    print('Error unsubscribing from channel: $e');
  }
}
