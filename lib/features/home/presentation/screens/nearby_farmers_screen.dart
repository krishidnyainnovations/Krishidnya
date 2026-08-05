import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';

/// Nearby farmers from backend geo query.
class NearbyFarmersScreen extends ConsumerWidget {
  const NearbyFarmersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmersAsync = ref.watch(nearbyFarmersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Farmers')),
      body: farmersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => EmptyStateWidget(
          title: 'Nearby farmers unavailable',
          subtitle: e.toString(),
          icon: Icons.people_outline,
        ),
        data: (farmers) => farmers.isEmpty
            ? const EmptyStateWidget(
                title: 'No farmers nearby',
                subtitle: 'Update your location in profile to find farmers around you.',
                icon: Icons.people_outline,
              )
            : ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: farmers.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final f = farmers[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(f.name[0].toUpperCase()),
                      ),
                      title: Text(f.name),
                      subtitle: Text(
                        [
                          if (f.location != null) f.location,
                          if (f.distanceKm != null)
                            '${f.distanceKm!.toStringAsFixed(1)} km away',
                        ].join(' · '),
                      ),
                      trailing: f.mobile != null
                          ? const Icon(Icons.phone_outlined)
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
