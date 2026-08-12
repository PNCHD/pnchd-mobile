/// Mirrors the `role` check constraint on `profiles` (migration 001).
enum ProfileRole {
  owner,
  pro,
  client,
  driver,
  platformAdmin;

  static ProfileRole fromString(String value) => switch (value) {
    'owner' => ProfileRole.owner,
    'pro' => ProfileRole.pro,
    'client' => ProfileRole.client,
    'driver' => ProfileRole.driver,
    'platform_admin' => ProfileRole.platformAdmin,
    _ => throw ArgumentError('Unknown profile role: $value'),
  };

  /// Section 9.3: owner and pro share the same contractor app shell.
  bool get isContractor => this == ProfileRole.owner || this == ProfileRole.pro;
}

/// Mirrors the `profiles` table (migration 001). `organizationId` is
/// nullable until the signup flow attaches a newly created org.
class Profile {
  const Profile({
    required this.id,
    required this.role,
    this.organizationId,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.isActive = true,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String,
    organizationId: json['organization_id'] as String?,
    role: ProfileRole.fromString(json['role'] as String),
    fullName: json['full_name'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    phone: json['phone'] as String?,
    isActive: json['is_active'] as bool? ?? true,
  );

  final String id;
  final String? organizationId;
  final ProfileRole role;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final bool isActive;
}
