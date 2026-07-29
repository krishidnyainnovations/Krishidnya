import 'package:flutter/material.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';

/// Placeholder farm management screen.
class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Farm')),
      body: const EmptyStateWidget(
        title: 'Your farm awaits',
        subtitle:
            "Add your fields and crops to start tracking your farm's health and growth.",
        icon: Icons.agriculture_rounded,
      ),
    );
  }
}

/// Placeholder disease detection screen.
class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Scan')),
      body: const EmptyStateWidget(
        title: 'Scan your crops',
        subtitle:
            'Take a photo of affected leaves and our AI will identify diseases instantly.',
        icon: Icons.camera_alt_outlined,
      ),
    );
  }
}

/// Placeholder analytics screen.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const EmptyStateWidget(
        title: 'Insights coming soon',
        subtitle:
            'Track yield trends, cost analysis, and seasonal performance over time.',
        icon: Icons.analytics_outlined,
      ),
    );
  }
}

/// Placeholder profile screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const EmptyStateWidget(
        title: 'Your profile',
        subtitle: 'Manage your account, farm details, and preferences.',
        icon: Icons.person_outline_rounded,
      ),
    );
  }
}
