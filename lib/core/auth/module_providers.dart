import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/module_repository.dart';
import 'auth_providers.dart';

final moduleRepositoryProvider = Provider((ref) => ModuleRepository());

/// The current org's active module keys (Section 4.3 UI-level gating — RLS
/// via `has_active_module()` is the real security boundary, this just
/// hides nav for unsubscribed features).
///
/// One-shot fetch, not a live Realtime subscription — `module_subscriptions`
/// isn't in the `supabase_realtime` publication, so a module change shows
/// up on next login/resume, not instantly.
final activeModulesProvider = FutureProvider<Set<String>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final organizationId = profile?.organizationId;
  if (organizationId == null) return <String>{};

  final repo = ref.watch(moduleRepositoryProvider);
  return repo.fetchActiveModuleKeys(organizationId);
});
