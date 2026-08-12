import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/profile_repository.dart';
import '../models/profile.dart';
import '../supabase/supabase_client.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

/// Fires on session restore, sign-in, sign-out, and token refresh.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

/// The signed-in user's `profiles` row, null when signed out. What
/// role-based routing and module gating actually branch on — the JWT alone
/// only proves who, not what role.
final currentProfileProvider = StreamProvider<Profile?>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return supabase.auth.onAuthStateChange.asyncMap((state) async {
    final userId = state.session?.user.id;
    if (userId == null) return null;
    return repo.fetchById(userId);
  });
});
