import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '/flutter_flow/flutter_flow_util.dart';
import '/config/env.dart';

export 'database/database.dart';
export 'storage/storage.dart';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: Env.supabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: Env.supabaseAnonKey,
        debug: Env.enableSupabaseDebug,
        authOptions:
            const FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
