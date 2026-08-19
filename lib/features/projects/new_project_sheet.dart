import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/theme/app_theme.dart';
import 'project_providers.dart';

Future<void> showNewProjectSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _NewProjectSheet(),
  );
}

class _NewProjectSheet extends ConsumerStatefulWidget {
  const _NewProjectSheet();

  @override
  ConsumerState<_NewProjectSheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends ConsumerState<_NewProjectSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final profile = ref.read(currentProfileProvider).value;
    final organizationId = profile?.organizationId;
    if (profile == null || organizationId == null) {
      setState(() => _error = 'You need an organization before creating a project.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final address = _addressController.text.trim();
      await ref.read(projectRepositoryProvider).create(
        organizationId: organizationId,
        createdBy: profile.id,
        title: _titleController.text.trim(),
        address: address.isEmpty ? null : address,
      );
      ref.invalidate(projectsProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not create the project. Try again.';
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the sheet above the keyboard; without this the address field is
      // hidden behind it on smaller phones.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'New project',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Kitchen remodel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? 'Enter a title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Job site address (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.brandRed)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(_isSubmitting ? 'Creating…' : 'Create project'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
