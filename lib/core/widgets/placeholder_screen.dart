import 'package:flutter/material.dart';

/// Shared shell for every not-yet-built feature screen, so the same
/// `Scaffold`/`AppBar`/centered-text boilerplate isn't duplicated per
/// screen. Delete a screen's usage of this once it has a real body.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — placeholder')),
    );
  }
}
