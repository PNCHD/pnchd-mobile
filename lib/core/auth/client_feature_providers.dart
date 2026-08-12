import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/client_feature_repository.dart';
import 'auth_providers.dart';

final clientFeatureRepositoryProvider = Provider((ref) => ClientFeatureRepository());

/// Owner-controlled on/off switches for client-facing capabilities
/// (`client_feature_toggles`), independent of module billing status — an
/// org can pay for document_signing without exposing it to clients yet.
///
/// UI-only gate, not enforced in RLS yet (see the migration's comment).
final clientFeatureTogglesProvider = FutureProvider<Set<String>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final organizationId = profile?.organizationId;
  if (organizationId == null) return <String>{};

  final repo = ref.watch(clientFeatureRepositoryProvider);
  return repo.fetchEnabledFeatureKeys(organizationId);
});
