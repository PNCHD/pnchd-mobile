import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client.dart';

/// Wraps Supabase auth so nothing outside the data layer reaches the global
/// client. Without this seam there's no way to drive auth state in a test
/// without initializing real Supabase.
class AuthRepository {
  AuthRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<void> signOut() => _client.auth.signOut();
}
