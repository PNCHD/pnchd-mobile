import 'package:flutter_test/flutter_test.dart';
import 'package:pnchd_mobile/core/models/project.dart';

Project _project(String id, ProjectStatus status) => Project(
  id: id,
  organizationId: 'o1',
  title: 'Project $id',
  status: status,
  createdBy: 'u1',
);

final _all = [
  _project('a', ProjectStatus.draft),
  _project('b', ProjectStatus.active),
  _project('c', ProjectStatus.onHold),
  _project('d', ProjectStatus.completed),
  _project('e', ProjectStatus.archived),
];

List<String> _ids(List<Project> projects) => projects.map((p) => p.id).toList();

void main() {
  group('ProjectStatus', () {
    test('maps every database value', () {
      expect(ProjectStatus.fromValue('draft'), ProjectStatus.draft);
      expect(ProjectStatus.fromValue('active'), ProjectStatus.active);
      expect(ProjectStatus.fromValue('on_hold'), ProjectStatus.onHold);
      expect(ProjectStatus.fromValue('completed'), ProjectStatus.completed);
      expect(ProjectStatus.fromValue('archived'), ProjectStatus.archived);
    });

    test('throws on an unrecognized value rather than guessing', () {
      expect(() => ProjectStatus.fromValue('nope'), throwsArgumentError);
    });

    test('snake_case DB value is preserved, not the enum name', () {
      // on_hold must round-trip exactly or the insert violates the check
      // constraint.
      expect(ProjectStatus.onHold.value, 'on_hold');
    });

    test('isOpen covers draft, active, and on hold only', () {
      expect(ProjectStatus.draft.isOpen, isTrue);
      expect(ProjectStatus.active.isOpen, isTrue);
      expect(ProjectStatus.onHold.isOpen, isTrue);
      expect(ProjectStatus.completed.isOpen, isFalse);
      expect(ProjectStatus.archived.isOpen, isFalse);
    });
  });

  group('Project.fromJson', () {
    test('maps a full row', () {
      final project = Project.fromJson({
        'id': 'p1',
        'organization_id': 'o1',
        'title': 'Kitchen remodel',
        'description': 'Full gut',
        'status': 'active',
        'client_id': 'c1',
        'address': '123 Main St',
        'start_date': '2026-09-01',
        'end_date': null,
        'created_by': 'u1',
      });

      expect(project.id, 'p1');
      expect(project.title, 'Kitchen remodel');
      expect(project.status, ProjectStatus.active);
      expect(project.address, '123 Main St');
      expect(project.endDate, isNull);
    });

    test('tolerates the nullable columns being absent', () {
      final project = Project.fromJson({
        'id': 'p2',
        'organization_id': 'o1',
        'title': 'Minimal',
        'status': 'draft',
        'created_by': 'u1',
      });

      expect(project.description, isNull);
      expect(project.address, isNull);
      expect(project.clientId, isNull);
    });
  });

  group('filterProjects', () {
    test('open covers draft, active, and on hold', () {
      expect(_ids(filterProjects(_all, ProjectFilter.open)), ['a', 'b', 'c']);
    });

    test('all returns everything', () {
      expect(filterProjects(_all, ProjectFilter.all).length, _all.length);
    });

    test('a specific status returns only that status', () {
      expect(
        _ids(filterProjects(_all, ProjectFilter.status(ProjectStatus.completed))),
        ['d'],
      );
    });

    test('returns empty rather than throwing when nothing matches', () {
      final drafts = [_project('a', ProjectStatus.draft)];
      expect(
        filterProjects(drafts, ProjectFilter.status(ProjectStatus.archived)),
        isEmpty,
      );
    });

    test('status filters compare by value, so chip selection works', () {
      // The filter bar compares the selected filter against list entries; without
      // value equality every chip would render unselected.
      expect(
        ProjectFilter.status(ProjectStatus.active),
        ProjectFilter.status(ProjectStatus.active),
      );
    });

    test('exposes one filter per status plus open and all', () {
      expect(ProjectFilter.values.length, ProjectStatus.values.length + 2);
    });
  });
}
