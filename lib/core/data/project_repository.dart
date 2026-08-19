import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/project.dart';
import '../supabase/supabase_client.dart';

/// Explicit column list rather than `*` (Section 13.3) — keeps the payload
/// predictable and stops a future column from silently widening what ships to
/// the device.
const _columns =
    'id, organization_id, title, description, status, client_id, address, '
    'start_date, end_date, created_by';

class ProjectRepository {
  ProjectRepository([SupabaseClient? client]) : _client = client ?? supabase;

  final SupabaseClient _client;

  /// No organization filter: RLS already scopes this to the caller's org, and
  /// filtering here would imply the isolation lives in the app rather than the
  /// database.
  Future<List<Project>> list() async {
    final rows = await _client
        .from('projects')
        .select(_columns)
        .order('updated_at', ascending: false);

    return rows.map(Project.fromJson).toList();
  }

  Future<Project?> getById(String id) async {
    final row = await _client
        .from('projects')
        .select(_columns)
        .eq('id', id)
        .maybeSingle();

    return row == null ? null : Project.fromJson(row);
  }

  Future<Project> create({
    required String organizationId,
    required String createdBy,
    required String title,
    String? address,
    ProjectStatus status = ProjectStatus.draft,
  }) async {
    final row = await _client
        .from('projects')
        .insert({
          'organization_id': organizationId,
          'created_by': createdBy,
          'title': title,
          'address': address,
          'status': status.value,
        })
        .select(_columns)
        .single();

    return Project.fromJson(row);
  }

  Future<Project> updateStatus(String id, ProjectStatus status) async {
    final row = await _client
        .from('projects')
        .update({'status': status.value})
        .eq('id', id)
        .select(_columns)
        .single();

    return Project.fromJson(row);
  }
}
