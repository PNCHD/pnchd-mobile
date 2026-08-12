import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile.dart';
import '../supabase/supabase_client.dart';

class ProfileRepository {
  ProfileRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<Profile?> fetchById(String userId) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return row == null ? null : Profile.fromJson(row);
  }
}
