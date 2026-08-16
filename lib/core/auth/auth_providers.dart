import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/auth_repository.dart';
import '../data/organization_repository.dart';
import '../data/profile_repository.dart';
import '../models/profile.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

final organizationRepositoryProvider = Provider((ref) => OrganizationRepository());

/// Fires on session restore, sign-in, sign-out, and token refresh.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).onAuthStateChange;
});

/// The signed-in user's `profiles` row, null when signed out. What
/// role-based routing and module gating actually branch on — the JWT alone
/// only proves who, not what role.
final currentProfileProvider = StreamProvider<Profile?>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final profiles = ref.watch(profileRepositoryProvider);

  return auth.onAuthStateChange.asyncMap((state) async {
    final userId = state.session?.user.id;
    if (userId == null) return null;
    return profiles.fetchById(userId);
  });
});
