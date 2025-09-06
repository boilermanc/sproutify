import 'package:flutter/foundation.dart';

class Env {
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xzckfyipgrgpwnydddev.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
  );

  // RevenueCat Configuration
  static const String revenueCatApiKey = String.fromEnvironment(
    'REVENUE_CAT_API_KEY',
    defaultValue: 'appl_szgNwIyKqHcKLtwDsoMEvuwPtOi',
  );

  // External API URLs
  static const String n8nWebhookUrl = String.fromEnvironment(
    'N8N_WEBHOOK_URL',
    defaultValue: 'https://n8n.sproutify.app/webhook/a9aae518-ec85-4b0d-b2cb-5e6f64c5783d',
  );

  // Development/Production flags
  static bool get isProduction => kReleaseMode;
  static bool get isDevelopment => kDebugMode;
  
  // Debug settings
  static bool get enableDebugLogging => isDevelopment;
  static bool get enableSupabaseDebug => isDevelopment;
}
