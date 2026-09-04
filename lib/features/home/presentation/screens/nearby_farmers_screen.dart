import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';
import 'package:cropdoc/features/home/domain/entities/feature_models.dart';
import 'package:cropdoc/features/home/presentation/controllers/home_providers.dart';
import 'package:cropdoc/l10n/app_localizations.dart';
import 'package:cropdoc/widgets/feedback/app_snackbar.dart';
import 'package:cropdoc/widgets/feedback/empty_state_widget.dart';
import 'package:url_launcher/url_launcher.dart';

/// Nearby farmers from backend geo query.
class NearbyFarmersScreen extends ConsumerWidget {
  const NearbyFarmersScreen({super.key});

  Future<void> _callFarmer(
    BuildContext context,
    AppLocalizations l10n,
    String phone,
  ) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      AppSnackBar.error(context, l10n.couldNotOpenDialer);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final farmersAsync = ref.watch(nearbyFarmersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nearbyFarmers)),
      body: farmersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => EmptyStateWidget(
          title: l10n.nearbyUnavailable,
          subtitle: e.toString(),
          icon: Icons.people_outline,
        ),
        data: (farmers) => farmers.isEmpty
            ? EmptyStateWidget(
                title: l10n.noFarmersNearby,
                subtitle: l10n.updateLocationNearby,
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
                            l10n.kmAway(f.distanceKm!.toStringAsFixed(1)),
                        ].join(' · '),
                      ),
                      trailing: f.mobile != null
                          ? IconButton(
                              icon: const Icon(Icons.phone_outlined),
                              tooltip: f.mobile,
                              onPressed: () =>
                                  _callFarmer(context, l10n, f.mobile!),
                            )
                          : null,
                      onTap: f.mobile != null
                          ? () => _callFarmer(context, l10n, f.mobile!)
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
