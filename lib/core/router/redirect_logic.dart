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

/// Org setup, for a signed-in contractor whose profile has no org yet.
const orgSetupPath = '/welcome';

// platform_admin has no real mobile home (that's the web admin dashboard,
// Section 15.3) — routed to /dashboard as a fallback.
String homeFor(ProfileRole role) => switch (role) {
  ProfileRole.client => '/client',
  ProfileRole.driver => '/driver',
  ProfileRole.owner || ProfileRole.pro || ProfileRole.platformAdmin => '/dashboard',
};

bool isContractorPath(String path) =>
    contractorPathPrefixes.any((prefix) => path.startsWith(prefix));

/// Signed in, but not yet attached to an organization. handle_new_user creates
/// the profile with organization_id NULL and the signup flow fills it in, so
/// this is the normal state between clicking the magic link and finishing
/// setup — not an error.
///
/// platform_admin is exempt: that role is cross-org by design and has no
/// organization of its own.
bool needsOrganizationSetup(Profile profile) =>
    profile.role != ProfileRole.platformAdmin && profile.organizationId == null;

/// Section 9.3 role-based routing, as a pure function of (profile, path) so
/// it's unit-testable without a real GoRouter/widget tree.
String? resolveRedirect(Profile? profile, String path) {
  final onOnboarding = path == '/onboarding';

  if (profile == null) {
    return onOnboarding ? null : '/onboarding';
  }

  // Clients and drivers never create organizations — the contractor invites
  // them — so they go to their own shell even without one, and see whatever
  // their (empty) scope allows.
  if (needsOrganizationSetup(profile) && profile.role.isContractor) {
    return path == orgSetupPath ? null : orgSetupPath;
  }

  if (path == orgSetupPath) {
    return homeFor(profile.role);
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
