import 'package:flutter/material.dart';

class BillingSettingsScreen extends StatelessWidget {
  const BillingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: const Center(child: Text('Billing settings — placeholder')),
    );
  }
}
