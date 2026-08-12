import 'package:flutter/material.dart';

/// Placeholder shell for role: driver. Section 9.3: real version needs
/// assigned jobs, active job detail, GPS status indicator, progress photo
/// upload. Background location (Section 9.4) only starts once a job is
/// active — not wired here yet.
class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PNCHD')),
      body: const Center(child: Text('Driver home — placeholder')),
    );
  }
}
