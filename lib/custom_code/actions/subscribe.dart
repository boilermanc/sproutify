// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!



Future<void> subscribe(String table, Future Function() callbackAction) async {
  SupaFlow.client
      .channel('realtime:$table')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: table,
        callback: (PostgresChangePayload payload) async {
          await callbackAction();
        },
      )
      .subscribe();
}
