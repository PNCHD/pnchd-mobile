import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

/// Not yet wired into any route — messaging is a roadmap module
/// (Section 2.2, after 50 subscribers).
class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Messages');
}
