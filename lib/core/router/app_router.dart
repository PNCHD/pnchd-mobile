import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/client_view/client_home_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/document_signing/document_signing_screen.dart';
import '../../features/driver_view/driver_home_screen.dart';
import '../../features/fleet_tracking/fleet_tracking_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/org_setup_screen.dart';
import '../../features/projects/projects_screen.dart';
import '../../features/proposals_invoicing/proposals_invoicing_screen.dart';
import '../../features/scheduling/scheduling_screen.dart';
import '../../features/settings/account/account_settings_screen.dart';
import '../../features/settings/billing/billing_settings_screen.dart';
import '../../features/settings/organization/organization_settings_screen.dart';
import '../../features/settings/team/team_settings_screen.dart';
import '../auth/auth_providers.dart';
import 'contractor_shell.dart';
import 'redirect_logic.dart';

/// Section 9.1: GoRouter config + role guards.
///
/// `refreshListenable` fires on every `currentProfileProvider` change — via
/// `ref.listen`, not the raw auth stream directly. That distinction matters:
/// the raw stream fires synchronously, but `currentProfileProvider` does an
/// async transform on top of it (even the no-session case costs a microtask,
/// since it's still an `async` function), so listening to the raw stream
/// triggers a redirect check *before* the provider value it reads has
/// actually updated — a real race that silently stalls the redirect forever
/// with nothing to trigger a second attempt.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(currentProfileProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: refresh,
    redirect: (context, state) {
      final profileAsync = ref.read(currentProfileProvider);
      return profileAsync.when(
        data: (profile) => resolveRedirect(profile, state.matchedLocation),
        loading: () => null,
        error: (_, _) => '/onboarding',
      );
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const OrgSetupScreen(),
      ),
      GoRoute(
        path: '/client',
        builder: (context, state) => const ClientHomeScreen(),
      ),
      GoRoute(
        path: '/driver',
        builder: (context, state) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: '/settings/account',
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/billing',
        builder: (context, state) => const BillingSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/team',
        builder: (context, state) => const TeamSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/organization',
        builder: (context, state) => const OrganizationSettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ContractorShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scheduling',
                builder: (context, state) => const SchedulingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/documents',
                builder: (context, state) => const DocumentSigningScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/proposals',
                builder: (context, state) => const ProposalsInvoicingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/fleet',
                builder: (context, state) => const FleetTrackingScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
