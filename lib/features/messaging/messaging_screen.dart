import 'package:flutter/material.dart';

/// Not yet wired into any route — messaging is a roadmap module
/// (Section 2.2, after 50 subscribers), gated by both `has_active_module`
/// and the new `client_feature_toggles` row once either exists for real.
class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(child: Text('Messaging — placeholder')),
    );
  }
}
