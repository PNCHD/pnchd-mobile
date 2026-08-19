import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/project.dart';
import '../../core/widgets/status_chip.dart';
import 'new_project_sheet.dart';
import 'project_providers.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(filteredProjectsProvider);
    final total = ref.watch(projectsProvider).value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showNewProjectSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: Column(
        children: [
          const _FilterBar(),
          Expanded(
            child: projects.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _Message(
                text: 'Could not load projects.\n$error',
                onRetry: () => ref.invalidate(projectsProvider),
              ),
              data: (visible) {
                if (visible.isEmpty) {
                  return _Message(
                    text: total == 0
                        ? 'No projects yet.\nTap New to create your first one.'
                        : 'No projects match this filter.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(projectsProvider),
                  child: _ProjectList(projects: visible),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(projectFilterProvider);

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: ProjectFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = ProjectFilter.values[index];
          return ChoiceChip(
            label: Text(filter.label),
            selected: filter == selected,
            onSelected: (_) =>
                ref.read(projectFilterProvider.notifier).select(filter),
          );
        },
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Section 9.5: on a tablet, cap the column width instead of stretching
        // rows edge to edge, which is unreadable at that measure.
        final horizontalPadding = constraints.maxWidth > 720
            ? (constraints.maxWidth - 720) / 2
            : 0.0;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          itemCount: projects.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              title: Text(project.title),
              subtitle: project.address == null ? null : Text(project.address!),
              trailing: StatusChip(status: project.status),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
