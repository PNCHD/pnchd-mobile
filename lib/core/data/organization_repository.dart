import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client.dart';

class OrganizationRepository {
  OrganizationRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  /// Creates an organization and attaches the signing-up user to it.
  ///
  /// Two writes, in this order because RLS forces it: the insert policy on
  /// organizations requires `owner_id = auth.uid()`, and the profile can only
  /// point at an org that already exists.
  ///
  /// Not atomic. A failure on the second write orphans the org row but leaves
  /// the user unattached and able to retry — the safe direction to fail.
  /// Collapsing both into a SECURITY DEFINER function is tracked in HANDOFF.
  Future<String> createForOwner({
    required String userId,
    required String name,
  }) async {
    final org = await _client
        .from('organizations')
        .insert({'name': name, 'owner_id': userId})
        .select('id')
        .single();

    final organizationId = org['id'] as String;

    await _client
        .from('profiles')
        .update({'organization_id': organizationId})
        .eq('id', userId);

    return organizationId;
  }
}
