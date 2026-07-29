import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// Government schemes listing with apply flow.
class SchemesScreen extends ConsumerWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemesAsync = ref.watch(schemesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Government Schemes')),
      body: schemesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(child: Text('Could not load schemes: $e')),
        data: (schemes) => schemes.isEmpty
            ? const Center(child: Text('No schemes available right now'))
            : ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: schemes.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) =>
                    _SchemeCard(scheme: schemes[i]),
              ),
      ),
    );
  }
}

class _SchemeCard extends ConsumerWidget {
  const _SchemeCard({required this.scheme});

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
              Text(
                'Apply for ${scheme.title}',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Our team will fill the form for you',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Full Name',
                controller: nameController,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mobile Number',
                controller: mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Village Name',
                controller: villageController,
              ),
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
    return Card(
      child: Padding(
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
            PrimaryButton(
              label: 'Apply',
              onPressed: () => _showApplySheet(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
