import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/module_providers.dart';

/// Bottom-nav shell for owner/pro (Section 9.3). Tabs are gated by active
/// modules (Section 4.3) — UI nicety, RLS is the real security boundary.
/// `dashboard`/`projects` are core and always visible.
class ContractorShell extends ConsumerWidget {
  const ContractorShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _branchModules = <int, String?>{
    0: null, // dashboard — core
    1: null, // projects — core
    2: 'scheduling',
    3: 'document_signing',
    4: 'proposals_invoicing',
    5: 'fleet_tracking',
  };

  static const _branchNav = <int, (String, IconData)>{
    0: ('Home', Icons.home_outlined),
    1: ('Projects', Icons.work_outline),
    2: ('Schedule', Icons.calendar_today_outlined),
    3: ('Documents', Icons.description_outlined),
    4: ('Proposals', Icons.request_quote_outlined),
    5: ('Fleet', Icons.local_shipping_outlined),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeModules =
        ref.watch(activeModulesProvider).value ?? const <String>{};

    final visibleBranches = _branchModules.entries
        .where(
          (entry) => entry.value == null || activeModules.contains(entry.value),
        )
        .map((entry) => entry.key)
        .toList();

    final selectedIndex = visibleBranches
        .indexOf(navigationShell.currentIndex)
        .clamp(0, visibleBranches.length - 1);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (tappedIndex) {
          final branchIndex = visibleBranches[tappedIndex];
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
        destinations: [
          for (final branchIndex in visibleBranches)
            NavigationDestination(
              icon: Icon(_branchNav[branchIndex]!.$2),
              label: _branchNav[branchIndex]!.$1,
            ),
        ],
      ),
    );
  }
}
