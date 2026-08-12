import '../models/profile.dart';

const contractorPathPrefixes = [
  '/dashboard',
  '/projects',
  '/scheduling',
  '/documents',
  '/proposals',
  '/fleet',
  '/settings',
];

// platform_admin has no real mobile home (that's the web admin dashboard,
// Section 15.3) — routed to /dashboard as a fallback.
String homeFor(ProfileRole role) => switch (role) {
  ProfileRole.client => '/client',
  ProfileRole.driver => '/driver',
  ProfileRole.owner || ProfileRole.pro || ProfileRole.platformAdmin => '/dashboard',
};

bool isContractorPath(String path) =>
    contractorPathPrefixes.any((prefix) => path.startsWith(prefix));

/// Section 9.3 role-based routing, as a pure function of (profile, path) so
/// it's unit-testable without a real GoRouter/widget tree.
String? resolveRedirect(Profile? profile, String path) {
  final onOnboarding = path == '/onboarding';

  if (profile == null) {
    return onOnboarding ? null : '/onboarding';
  }

  if (onOnboarding) {
    return homeFor(profile.role);
  }

  final home = homeFor(profile.role);
  final onOwnArea = switch (home) {
    '/client' => path.startsWith('/client'),
    '/driver' => path.startsWith('/driver'),
    _ => isContractorPath(path),
  };

  return onOwnArea ? null : home;
}
