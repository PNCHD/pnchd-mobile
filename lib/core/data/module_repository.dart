import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client.dart';

class ModuleRepository {
  ModuleRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<Set<String>> fetchActiveModuleKeys(String organizationId) async {
    final rows = await _client
        .from('module_subscriptions')
        .select('module_key')
        .eq('organization_id', organizationId)
        .eq('is_active', true);
    return rows.map((row) => row['module_key'] as String).toSet();
  }
}
