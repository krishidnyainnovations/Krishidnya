import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// Detailed government scheme view with apply flow.
class SchemeDetailScreen extends ConsumerWidget {
  const SchemeDetailScreen({required this.schemeId, super.key});

  final int schemeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemeAsync = ref.watch(schemeDetailProvider(schemeId));

    return Scaffold(
      appBar: AppBar(title: const Text('Scheme Details')),
      body: schemeAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(child: Text('Could not load scheme: $e')),
        data: (scheme) => _SchemeDetailBody(scheme: scheme),
      ),
    );
  }
}

class _SchemeDetailBody extends ConsumerWidget {
  const _SchemeDetailBody({required this.scheme});

  final Scheme scheme;

  Future<void> _showApplySheet(BuildContext context, WidgetRef ref) async {
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
              Text('Apply for ${scheme.title}',
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Full Name', controller: nameController),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mobile Number',
                controller: mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Village Name', controller: villageController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Submit Application',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        if (nameController.text.isEmpty ||
                            mobileController.text.isEmpty ||
                            villageController.text.isEmpty) {
                          AppSnackBar.error(ctx, 'Please fill all fields');
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
                              'Application submitted! Our team will contact you.',
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
    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        if (scheme.imageUrl != null) ...[
          ClipRRect(
            borderRadius: AppSpacing.cardRadius,
            child: CachedNetworkImage(
              imageUrl: scheme.imageUrl!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
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
        const SizedBox(height: AppSpacing.md),
        Text(scheme.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Text(scheme.description),
        if (scheme.eligibilityCriteria != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Eligibility', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(scheme.eligibilityCriteria!),
        ],
        if (scheme.benefits != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Benefits', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(scheme.benefits!),
        ],
        if (scheme.howToApply != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('How to Apply', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(scheme.howToApply!),
        ],
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: 'Apply Now',
          onPressed: () => _showApplySheet(context, ref),
        ),
      ],
    );
  }
}
