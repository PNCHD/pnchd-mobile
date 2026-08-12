import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

/// Not yet wired into any route — the client's Stripe Connect payment flow
/// belongs under an invoice detail screen once `client_view` is built out
/// for real, not the contractor's bottom nav.
class ClientPaymentsScreen extends StatelessWidget {
  const ClientPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Payment');
}
