import 'package:flutter/material.dart';

/// Placeholder shell for role: client. Section 9.3: real version needs
/// projects view, documents to sign, invoices to pay, proposal approval —
/// each gated by both `has_active_module()` (RLS) and
/// `client_feature_toggles`/`is_client_feature_enabled()` (owner's
/// independent on/off switch) once built out for real.
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PNCHD')),
      body: const Center(child: Text('Client home — placeholder')),
    );
  }
}
