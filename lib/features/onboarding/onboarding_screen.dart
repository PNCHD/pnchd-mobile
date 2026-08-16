import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/auth_scaffold.dart';

/// Magic-link sign-in, which is also signup — `shouldCreateUser` provisions the
/// account on first use. Completing the link is handled by supabase_flutter's
/// deep-link listener; this screen only sends it.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSending = false;
  bool _isSent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSending = true;
      _error = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .sendMagicLink(_emailController.text.trim());
      if (mounted) setState(() => _isSent = true);
    } catch (error) {
      if (mounted) setState(() => _error = _messageFor(error));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSent) {
      return AuthScaffold(
        title: 'Check your email',
        children: [
          Text(
            'We sent a sign-in link to ${_emailController.text.trim()}. '
            'Open it on this device to continue.',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => setState(() => _isSent = false),
            child: const Text('Use a different email'),
          ),
        ],
      );
    }

    return AuthScaffold(
      title: 'Sign in to PNCHD',
      children: [
        const Text(
          "We'll email you a link — no password needed. New here? This creates "
          'your account.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email address',
              hintText: 'you@company.com',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Enter your email address';
              if (!email.contains('@') || !email.contains('.')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.brandRed)),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _isSending ? null : _submit,
          child: Text(_isSending ? 'Sending…' : 'Email me a sign-in link'),
        ),
      ],
    );
  }
}

/// Supabase rate-limits auth emails; surfacing the raw error is unhelpful, and
/// the rate-limit case is the one users will actually hit.
String _messageFor(Object error) {
  final message = error.toString();
  if (message.contains('rate limit') || message.contains('60 seconds')) {
    return 'Too many attempts. Wait a minute and try again.';
  }
  return 'Could not send the link. Check the address and try again.';
}
