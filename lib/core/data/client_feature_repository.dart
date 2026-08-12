import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client.dart';

class ClientFeatureRepository {
  ClientFeatureRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<Set<String>> fetchEnabledFeatureKeys(String organizationId) async {
    final rows = await _client
        .from('client_feature_toggles')
        .select('feature_key')
        .eq('organization_id', organizationId)
        .eq('is_enabled', true);
    return rows.map((row) => row['feature_key'] as String).toSet();
  }
}
