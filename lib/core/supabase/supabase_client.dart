import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes the Supabase client. Call once from `main()` before
/// `runApp()`.
///
/// SUPABASE_URL and SUPABASE_ANON_KEY are passed at build time via
/// `--dart-define` (architecture doc Section 11.3) — never hardcoded here.
/// The anon key is safe to compile into the app; RLS enforces access.
Future<void> initSupabase() async {
  const url = String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  assert(url.isNotEmpty, 'SUPABASE_URL must be passed via --dart-define');
  assert(
    anonKey.isNotEmpty,
    'SUPABASE_ANON_KEY must be passed via --dart-define',
  );

  await Supabase.initialize(url: url, publishableKey: anonKey);
}

/// Shorthand accessor for the initialized Supabase client.
SupabaseClient get supabase => Supabase.instance.client;
