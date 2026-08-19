import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/data/project_repository.dart';
import '../../core/models/project.dart';

final projectRepositoryProvider = Provider((ref) => ProjectRepository());

/// Projects for the signed-in user's org. Empty (not an error) while the user
/// has no organization — every row would be filtered out by RLS anyway, so the
/// request is skipped rather than made and discarded.
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile?.organizationId == null) return const [];

  return ref.watch(projectRepositoryProvider).list();
});

/// Riverpod 3.x removed StateProvider; a Notifier is the replacement for
/// simple mutable UI state.
class ProjectFilterNotifier extends Notifier<ProjectFilter> {
  @override
  ProjectFilter build() => ProjectFilter.open;

  void select(ProjectFilter filter) => state = filter;
}

final projectFilterProvider =
    NotifierProvider<ProjectFilterNotifier, ProjectFilter>(
      ProjectFilterNotifier.new,
    );

/// The list as displayed. Derived rather than filtered in the widget so the
/// filtering is testable on its own.
final filteredProjectsProvider = Provider<AsyncValue<List<Project>>>((ref) {
  final filter = ref.watch(projectFilterProvider);
  return ref
      .watch(projectsProvider)
      .whenData((projects) => filterProjects(projects, filter));
});
