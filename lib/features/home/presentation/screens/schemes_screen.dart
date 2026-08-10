import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// Government schemes listing with search, filter, and apply flow.
class SchemesScreen extends ConsumerStatefulWidget {
  const SchemesScreen({super.key});

  @override
  ConsumerState<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends ConsumerState<SchemesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applySearch() {
    ref.read(schemesSearchProvider.notifier).state =
        _searchController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final schemesAsync = ref.watch(schemesProvider);
    final typeFilter = ref.watch(schemesTypeFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.governmentSchemes)),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.searchSchemes,
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _applySearch,
                ),
              ],
            ),
          ),
          schemesAsync.maybeWhen(
            data: (schemes) {
              final types = schemes.map((s) => s.schemeType).toSet().toList()
                ..sort();
              if (types.isEmpty) return const SizedBox.shrink();
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(l10n.all),
                      selected: typeFilter == null,
                      onSelected: (_) =>
                          ref.read(schemesTypeFilterProvider.notifier).state =
                              null,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    ...types.map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: FilterChip(
                          label: Text(t),
                          selected: typeFilter == t,
                          onSelected: (_) => ref
                              .read(schemesTypeFilterProvider.notifier)
                              .state = t,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: schemesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) =>
                  Center(child: Text(l10n.couldNotLoadSchemes('$e'))),
              data: (schemes) => schemes.isEmpty
                  ? Center(child: Text(l10n.noSchemesMatch))
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(schemesProvider),
                      child: ListView.separated(
                        padding: AppSpacing.screenPadding,
                        itemCount: schemes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) =>
                            _SchemeCard(scheme: schemes[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SchemeCard extends ConsumerWidget {
  const _SchemeCard({required this.scheme});

  final Scheme scheme;

  Future<void> _showApplySheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(
      text: ref.read(currentUserProvider).valueOrNull?.fullName ?? '',
    );
    final mobileController = TextEditingController(
      text: ref.read(currentUserProvider).valueOrNull?.mobile ?? '',
    );
    final villageController = TextEditingController();
    var isLoading = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.applyForTitle(scheme.title),
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.teamFillForm,
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: l10n.fullName,
                controller: nameController,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.mobileNumber,
                controller: mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.villageName,
                controller: villageController,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: l10n.submitApplication,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        if (nameController.text.isEmpty ||
                            mobileController.text.isEmpty ||
                            villageController.text.isEmpty) {
                          AppSnackBar.error(ctx, l10n.fillAllFields);
                          return;
                        }
                        setState(() => isLoading = true);
                        final userId = int.tryParse(
                          ref.read(currentUserProvider).valueOrNull?.id ?? '',
                        );
                        final result = await ref
                            .read(homeRepositoryProvider)
                            .applyScheme(
                              schemeId: scheme.id,
                              name: nameController.text.trim(),
                              mobile: mobileController.text.trim(),
                              villageName: villageController.text.trim(),
                              userId: userId,
                            );
                        if (!ctx.mounted) return;
                        setState(() => isLoading = false);
                        switch (result) {
                          case Success():
                            Navigator.pop(ctx);
                            AppSnackBar.success(
                              context,
                              l10n.applicationSubmitted,
                            );
                          case ErrorResult(:final failure):
                            AppSnackBar.error(context, failure.message);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );

    nameController.dispose();
    mobileController.dispose();
    villageController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scheme.imageUrl != null)
            CachedNetworkImage(
              imageUrl: scheme.imageUrl!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        scheme.schemeType,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  scheme.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  scheme.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/schemes/${scheme.id}'),
                        child: Text(l10n.details),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PrimaryButton(
                        label: l10n.apply,
                        onPressed: () => _showApplySheet(context, ref),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
