import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client.dart';

/// Wraps Supabase auth so nothing outside the data layer reaches the global
/// client. Without this seam there's no way to drive auth state in a test
/// without initializing real Supabase.
class AuthRepository {
  AuthRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  /// Deep link the magic link returns to. Registered in Info.plist
  /// (CFBundleURLTypes) and AndroidManifest (intent-filter), and must also be
  /// listed as an allowed redirect URL in the Supabase Auth dashboard.
  static const magicLinkRedirect = 'io.pnchd.pnchd_mobile://login-callback';

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  String? get currentUserId => _client.auth.currentUser?.id;

  /// Sends a magic link. Doubles as signup — [shouldCreateUser] provisions the
  /// account on first use, so there is no separate register call.
  ///
  /// Completing the link is handled by supabase_flutter itself: it watches
  /// incoming deep links via app_links and establishes the session
  /// (`detectSessionInUri`, on by default), which surfaces here as an
  /// [onAuthStateChange] event. Nothing in the app parses the callback URL.
  Future<void> sendMagicLink(String email) {
    return _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: magicLinkRedirect,
      shouldCreateUser: true,
      data: const {'role': 'owner'},
    );
  }

  Future<void> signOut() => _client.auth.signOut();
}
