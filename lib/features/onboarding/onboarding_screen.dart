import 'package:flutter/material.dart';

/// Placeholder — real signup/login/org-setup/Stripe-onboarding flow
/// (Section 9.1) comes later. Shown whenever `currentProfileProvider` is
/// null, i.e. signed out.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PNCHD')),
      body: const Center(child: Text('Onboarding — placeholder')),
    );
  }
}
