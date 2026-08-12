import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

/// Section 9.3 real version needs: assigned jobs, active job detail, GPS
/// status indicator, progress photo upload. Background location
/// (Section 9.4) only starts once a job is active.
class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'PNCHD');
}
