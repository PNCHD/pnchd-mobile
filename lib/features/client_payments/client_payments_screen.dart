import 'package:flutter/material.dart';

/// Not yet wired into any route — this is the client's Stripe Connect
/// payment flow, which belongs under an invoice detail screen once
/// `client_view` is built out for real, not the contractor's bottom nav.
class ClientPaymentsScreen extends StatelessWidget {
  const ClientPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: const Center(child: Text('Client payments — placeholder')),
    );
  }
}
