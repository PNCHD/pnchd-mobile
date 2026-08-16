import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/auth_scaffold.dart';

/// Org setup, shown once between first sign-in and having a usable account.
///
/// Stripe subscription creation belongs here too (Section 10.2: signup starts
/// the 30-day trial). Not wired — no Stripe keys — so a contractor lands in the
/// app with an org but no subscription record. Tracked in HANDOFF.
class OrgSetupScreen extends ConsumerStatefulWidget {
  const OrgSetupScreen({super.key});

  @override
  ConsumerState<OrgSetupScreen> createState() => _OrgSetupScreenState();
}

class _OrgSetupScreenState extends ConsumerState<OrgSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      await ref.read(organizationRepositoryProvider).createForOwner(
        userId: profile.id,
        name: _nameController.text.trim(),
      );
      // currentProfileProvider is keyed off auth events, which this doesn't
      // emit — invalidate so it refetches and the router releases us.
      ref.invalidate(currentProfileProvider);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = 'Could not create your business. Try again.';
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Name your business',
      children: [
        const Text(
          'This is what your clients will see on proposals, invoices, and '
          'documents. You can change it later.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Business name',
              hintText: 'Acme Contracting',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value?.trim().isEmpty ?? true) ? 'Enter your business name' : null,
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.brandRed)),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: Text(_isSubmitting ? 'Setting up…' : 'Continue'),
        ),
      ],
    );
  }
}
