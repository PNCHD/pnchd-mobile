import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

/// Section 9.3 real version needs: projects view, documents to sign,
/// invoices to pay, proposal approval — each gated by both
/// `has_active_module()` (RLS) and `client_feature_toggles` (owner's
/// independent switch) once built out for real.
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'PNCHD');
}
