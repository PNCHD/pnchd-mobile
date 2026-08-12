import 'package:flutter/material.dart';

import '../../core/supabase/supabase_client.dart';

/// Placeholder — home screen, activity feed, module nav (Section 9.1)
/// comes later. Keeps the Supabase connectivity confirmation visible.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text('Supabase client connected to ${supabase.rest.url}'),
      ),
    );
  }
}
