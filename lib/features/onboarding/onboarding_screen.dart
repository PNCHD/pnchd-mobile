import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

/// Real signup/login/org-setup/Stripe-onboarding flow (Section 9.1) comes
/// later. Shown whenever `currentProfileProvider` is null, i.e. signed out.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'PNCHD');
}
