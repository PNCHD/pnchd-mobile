import 'package:flutter/material.dart';

import '../models/project.dart';
import '../theme/app_theme.dart';

/// Colour never carries the meaning alone — the label is always shown.
/// Colour-only status is unreadable for colour-blind users and invisible to
/// screen readers.
class StatusChip extends StatelessWidget {
  const StatusChip({required this.status, super.key});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      ProjectStatus.draft => (AppColors.navy.withValues(alpha: 0.10), AppColors.navy),
      ProjectStatus.active => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      ProjectStatus.onHold => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
      ProjectStatus.completed => (AppColors.navy, Colors.white),
      ProjectStatus.archived => (
        AppColors.navy.withValues(alpha: 0.05),
        AppColors.navy.withValues(alpha: 0.5),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: foreground,
        ),
      ),
    );
  }
}
