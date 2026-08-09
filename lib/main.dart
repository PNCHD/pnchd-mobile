import 'package:flutter/material.dart';

import 'core/supabase/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PNCHD',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const _SupabaseStatusPage(),
    );
  }
}

/// Placeholder home screen for Block B — confirms the Supabase client
/// initialized. Replaced once role-based navigation (Section 9.3) and the
/// full feature scaffolding (Section 9.1) land.
class _SupabaseStatusPage extends StatelessWidget {
  const _SupabaseStatusPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PNCHD')),
      body: Center(
        child: Text('Supabase client connected to ${supabase.rest.url}'),
      ),
    );
  }
}
