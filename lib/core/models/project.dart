/// Mirrors the `status` check constraint on `projects` (migration 003).
enum ProjectStatus {
  draft('draft', 'Draft'),
  active('active', 'Active'),
  onHold('on_hold', 'On hold'),
  completed('completed', 'Completed'),
  archived('archived', 'Archived');

  const ProjectStatus(this.value, this.label);

  final String value;
  final String label;

  static ProjectStatus fromValue(String value) => switch (value) {
    'draft' => ProjectStatus.draft,
    'active' => ProjectStatus.active,
    'on_hold' => ProjectStatus.onHold,
    'completed' => ProjectStatus.completed,
    'archived' => ProjectStatus.archived,
    // The DB constraint should make this unreachable; failing loudly beats
    // rendering an unknown status as if it were valid.
    _ => throw ArgumentError('Unknown project status: $value'),
  };

  /// Not finished — the default list view.
  bool get isOpen =>
      this == ProjectStatus.draft ||
      this == ProjectStatus.active ||
      this == ProjectStatus.onHold;
}

class Project {
  const Project({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.status,
    required this.createdBy,
    this.description,
    this.clientId,
    this.address,
    this.startDate,
    this.endDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'] as String,
    organizationId: json['organization_id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    status: ProjectStatus.fromValue(json['status'] as String),
    clientId: json['client_id'] as String?,
    address: json['address'] as String?,
    startDate: json['start_date'] as String?,
    endDate: json['end_date'] as String?,
    createdBy: json['created_by'] as String,
  );

  final String id;
  final String organizationId;
  final String title;
  final String? description;
  final ProjectStatus status;
  final String? clientId;
  final String? address;
  final String? startDate;
  final String? endDate;
  final String createdBy;
}

/// Filter options for the list view. Mirrors the web app's ProjectFilter.
sealed class ProjectFilter {
  const ProjectFilter();

  String get label;

  static const open = _OpenFilter();
  static const all = _AllFilter();

  static const values = <ProjectFilter>[
    open,
    all,
    _StatusFilter(ProjectStatus.draft),
    _StatusFilter(ProjectStatus.active),
    _StatusFilter(ProjectStatus.onHold),
    _StatusFilter(ProjectStatus.completed),
    _StatusFilter(ProjectStatus.archived),
  ];

  static ProjectFilter status(ProjectStatus status) => _StatusFilter(status);

  bool matches(Project project);
}

class _OpenFilter extends ProjectFilter {
  const _OpenFilter();
  @override
  String get label => 'Open';
  @override
  bool matches(Project project) => project.status.isOpen;
}

class _AllFilter extends ProjectFilter {
  const _AllFilter();
  @override
  String get label => 'All';
  @override
  bool matches(Project project) => true;
}

class _StatusFilter extends ProjectFilter {
  const _StatusFilter(this.status);
  final ProjectStatus status;
  @override
  String get label => status.label;
  @override
  bool matches(Project project) => project.status == status;

  @override
  bool operator ==(Object other) =>
      other is _StatusFilter && other.status == status;

  @override
  int get hashCode => status.hashCode;
}

List<Project> filterProjects(List<Project> projects, ProjectFilter filter) =>
    projects.where(filter.matches).toList();
