import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/data/home_repository.dart';
import 'package:krishidnya/features/home/data/local_farm_storage.dart';
import 'package:krishidnya/features/home/domain/entities/feature_models.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/l10n/app_localizations.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// AI crop recommendation with Gemini-powered results.
class CropRecommendationScreen extends ConsumerStatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  ConsumerState<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState
    extends ConsumerState<CropRecommendationScreen> {
  String _soilType = 'Loamy';
  String _season = 'Kharif';
  String _watering = 'Drip';
  final _areaController = TextEditingController(text: '1');
  bool _loading = false;
  CropRecommendationResult? _results;
  String? _soilApiSummary;

  static const _soils = ['Loamy', 'Clay', 'Sandy', 'Black', 'Red'];
  static const _seasons = ['Kharif', 'Rabi', 'Zaid'];
  static const _wateringTypes = ['Drip', 'Sprinkler', 'Flood', 'Rain-fed'];

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendations() async {
    setState(() {
      _loading = true;
      _results = null;
    });

    final user = ref.read(currentUserProvider).valueOrNull;
    final weather = ref.read(homeWeatherProvider).valueOrNull;
    final area = double.tryParse(_areaController.text.trim()) ?? 1;

    if (user?.latitude != null && user?.longitude != null) {
      final soilResult = await ref.read(homeRepositoryProvider).getSoilData(
            latitude: user!.latitude!,
            longitude: user.longitude!,
          );
      if (soilResult case Success(:final data)) {
        _soilApiSummary = data.toString();
        final apiSoil = data['soil_type'] as String?;
        if (apiSoil != null) {
          final match = _soils.firstWhere(
            (s) =>
                s.toLowerCase().contains(apiSoil.toLowerCase()) ||
                apiSoil.toLowerCase().contains(s.toLowerCase()),
            orElse: () => _soilType,
          );
          if (mounted) setState(() => _soilType = match);
        }
        final storage = await ref.read(localFarmStorageProvider.future);
        await storage.addSoilHistory(SoilHistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          soilType: data['soil_type'] as String? ?? _soilType,
          location: user.location ?? 'Farm',
          summary: data.toString(),
          createdAt: DateTime.now(),
        ));
      }
    }

    final result = await ref.read(homeRepositoryProvider).getCropRecommendations(
          soilType: _soilType,
          season: _season,
          watering: _watering,
          area: area,
          location: user?.location ?? user?.city ?? 'India',
          weatherSummary: weather != null
              ? '${weather.temperature}, ${weather.condition}, humidity ${weather.humidity ?? "N/A"}'
              : null,
          soilApiData: _soilApiSummary,
        );

    if (!mounted) return;

    switch (result) {
      case Success(:final data):
        setState(() {
          _loading = false;
          _results = data;
        });
        final storage = await ref.read(localFarmStorageProvider.future);
        await storage.addHistory(HistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'recommendation',
          title: 'Crop Recommendation — $_season',
          summary: 'Soil: $_soilType, Area: ${area}ac, Water: $_watering',
          createdAt: DateTime.now(),
        ));
        ref.invalidate(farmHistoryProvider);
      case ErrorResult(:final failure):
        setState(() => _loading = false);
        AppSnackBar.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cropRecommendation)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            l10n.tellUsAboutFarm,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          _DropdownField(
            label: l10n.soilType,
            value: _soilType,
            items: _soils,
            onChanged: (v) => setState(() => _soilType = v!),
          ),
          const SizedBox(height: AppSpacing.md),
          _DropdownField(
            label: l10n.season,
            value: _season,
            items: _seasons,
            onChanged: (v) => setState(() => _season = v!),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.farmAreaAcres,
            controller: _areaController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          _DropdownField(
            label: l10n.wateringMethod,
            value: _watering,
            items: _wateringTypes,
            onChanged: (v) => setState(() => _watering = v!),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.getTop4Crops,
            isLoading: _loading,
            icon: Icons.psychology_outlined,
            onPressed: _getRecommendations,
          ),
          if (_results != null) ...[
            const SizedBox(height: AppSpacing.xl),
            _WeatherAnalysisCard(analysis: _results!.weatherAnalysis),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.topCropPicks, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            ..._results!.crops.map((c) => _CropExpandableCard(crop: c)),
          ],
        ],
      ),
    );
  }
}

class _WeatherAnalysisCard extends StatelessWidget {
  const _WeatherAnalysisCard({required this.analysis});
  final WeatherAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      color: AppColors.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.weatherAnalysis,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _Row(l10n.temperature, analysis.temperature),
            _Row(l10n.humidity, analysis.humidity),
            _Row(l10n.expectedRain, analysis.expectedRain),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _CropExpandableCard extends StatelessWidget {
  const _CropExpandableCard({required this.crop});
  final RecommendedCrop crop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryContainer,
          child: Text(
            crop.name[0].toUpperCase(),
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(crop.name),
        subtitle: Text(
          '${l10n.harvestShort}: ${crop.daysToHarvest ?? '—'} · ${l10n.profit}: ${crop.expectedProfit ?? '—'}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(l10n.whyGrow, crop.why),
                _DetailRow(l10n.waterRequired, crop.waterRequired),
                _DetailRow(l10n.daysToHarvest, crop.daysToHarvest),
                _DetailRow(l10n.growingPeriod, crop.growingPeriod),
                _DetailRow(l10n.expectedProfit, crop.expectedProfit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

/// Scan crop for disease detection via Gemini AI.
class ScanCropFeatureScreen extends ConsumerStatefulWidget {
  const ScanCropFeatureScreen({super.key});

  @override
  ConsumerState<ScanCropFeatureScreen> createState() =>
      _ScanCropFeatureScreenState();
}

class _ScanCropFeatureScreenState extends ConsumerState<ScanCropFeatureScreen> {
  final _picker = ImagePicker();
  bool _loading = false;
  ScanCropResult? _result;
  String? _imagePath;

  Future<void> _pickAndScan(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    setState(() {
      _loading = true;
      _result = null;
      _imagePath = picked.path;
    });

    final scanResult = await ref.read(homeRepositoryProvider).scanCropImage(picked.path);

    if (!mounted) return;

    switch (scanResult) {
      case Success(:final data):
        final parsed = ScanCropResult.fromJson(data);
        setState(() {
          _loading = false;
          _result = parsed;
        });
        final storage = await ref.read(localFarmStorageProvider.future);
        await storage.addHistory(HistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'scan',
          title: parsed.disease,
          summary: parsed.organicCure ?? parsed.chemicalCure ?? 'Scan completed',
          createdAt: DateTime.now(),
        ));
        ref.invalidate(farmHistoryProvider);
      case ErrorResult(:final failure):
        setState(() => _loading = false);
        AppSnackBar.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanCrop)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          if (_imagePath != null)
            ClipRRect(
              borderRadius: AppSpacing.cardRadius,
              child: Image.file(
                File(_imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            EmptyStateWidget(
              title: l10n.scanYourCrop,
              subtitle: l10n.scanCropHelpText,
              icon: Icons.camera_alt_outlined,
            ),
          if (_loading)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.analyzingCropImage),
                ],
              ),
            ),
          if (_result != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _ScanResultCard(result: _result!),
          ],
        ],
      ),
      floatingActionButton: _loading
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showSourcePicker(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(l10n.takePhoto),
            ),
    );
  }

  void _showSourcePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.camera),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndScan(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.gallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndScan(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanResultCard extends StatelessWidget {
  const _ScanResultCard({required this.result});
  final ScanCropResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppColors.error.withValues(alpha: 0.08),
          child: ListTile(
            leading: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            title: Text(result.disease, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: result.confidence != null
                ? Text(l10n.confidenceLabel(result.confidence!))
                : null,
          ),
        ),
        if (result.organicCure != null) ...[
          const SizedBox(height: AppSpacing.md),
          _CureCard(
            title: l10n.organicCureRecommended,
            content: result.dosage != null
                ? '${result.organicCure}\n\n${l10n.dosageLabel}: ${result.dosage}'
                : result.organicCure!,
            color: AppColors.primary,
            icon: Icons.eco,
          ),
        ],
        if (result.chemicalCure != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _CureCard(
            title: l10n.chemicalCure,
            content: result.chemicalCure!,
            color: AppColors.accent,
            icon: Icons.science_outlined,
          ),
        ],
        if (result.products != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _CureCard(
            title: l10n.recommendedProducts,
            content: result.products!,
            color: AppColors.secondary,
            icon: Icons.shopping_bag_outlined,
          ),
        ],
        if (result.organicCure == null && result.chemicalCure == null)
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Text(result.raw.toString()),
            ),
          ),
      ],
    );
  }
}

class _CureCard extends StatelessWidget {
  const _CureCard({
    required this.title,
    required this.content,
    required this.color,
    required this.icon,
  });

  final String title;
  final String content;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(content),
          ],
        ),
      ),
    );
  }
}

/// Mandi prices from api.gov.in via backend.
class MandiPricesScreen extends ConsumerStatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  ConsumerState<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends ConsumerState<MandiPricesScreen> {
  final _commodityController = TextEditingController(text: 'Onion');
  final _stateController = TextEditingController(text: 'Maharashtra');
  Map<String, dynamic>? _prices;
  bool _loading = false;
  List<String> _favorites = [];
  List<String> _recent = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user?.state != null) {
        _stateController.text = user!.state!;
      }
      final mandiPrefs = await ref.read(mandiPreferencesProvider.future);
      setState(() {
        _favorites = mandiPrefs.getFavorites();
        _recent = mandiPrefs.getRecent();
      });
      await _fetch();
    });
  }

  @override
  void dispose() {
    _commodityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final crop = _commodityController.text.trim();
    final mandiPrefs = await ref.read(mandiPreferencesProvider.future);
    await mandiPrefs.addRecent(crop);
    final result = await ref.read(homeRepositoryProvider).getMandiPrices(
          commodity: crop,
          state: _stateController.text.trim(),
        );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _prices = switch (result) {
        Success(:final data) => data,
        ErrorResult(:final failure) => {'error': failure.message},
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mandiPrices)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppTextField(label: l10n.crop, controller: _commodityController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.stateLabel, controller: _stateController),
          if (_favorites.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.favorites, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: _favorites.map((f) {
                return ActionChip(
                  label: Text(f),
                  onPressed: () {
                    _commodityController.text = f;
                    _fetch();
                  },
                );
              }).toList(),
            ),
          ],
          if (_recent.where((r) => !_favorites.contains(r)).isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.recent, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: _recent.where((r) => !_favorites.contains(r)).map((r) {
                return ActionChip(
                  label: Text(r),
                  avatar: const Icon(Icons.history, size: 16),
                  onPressed: () {
                    _commodityController.text = r;
                    _fetch();
                  },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: l10n.fetchTodaysPrices,
            isLoading: _loading,
            onPressed: _fetch,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () async {
              final mandiPrefs = await ref.read(mandiPreferencesProvider.future);
              await mandiPrefs.addFavorite(_commodityController.text.trim());
              setState(() => _favorites = mandiPrefs.getFavorites());
              if (context.mounted) {
                AppSnackBar.success(context, l10n.addedToFavorites);
              }
            },
            child: Text(l10n.saveCropToFavorites),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_prices != null) _MandiPricesList(data: _prices!),
        ],
      ),
    );
  }
}

class _MandiPricesList extends StatelessWidget {
  const _MandiPricesList({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = parseMandiRecords(data);

    if (data.containsKey('error')) {
      return Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Text(data['error'].toString()),
        ),
      );
    }

    if (records.isEmpty) {
      return Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Text(l10n.noPriceData),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.todaysMarketRates,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...records.take(20).map((r) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                title: Text('${r['market'] ?? r['district'] ?? l10n.marketLabel}'),
                subtitle: Text(
                  '${r['commodity'] ?? ''} · ${r['variety'] ?? ''}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${r['modal_price'] ?? r['price'] ?? '—'}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    Text(
                      r['unit']?.toString() ?? '/quintal',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

}

/// Marketplace — farmer-to-farmer trading.
class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showListDialog(context, ref),
            tooltip: 'List item',
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => EmptyStateWidget(
          title: 'Marketplace',
          subtitle: 'Rent machinery, sell livestock, trade with farmers nearby.',
          icon: Icons.storefront_outlined,
          action: PrimaryButton(
            label: 'List Item',
            onPressed: () => _showListDialog(context, ref),
          ),
        ),
        data: (products) => products.isEmpty
            ? EmptyStateWidget(
                title: 'No listings yet',
                subtitle: 'Be the first to list tractors, seeds, or livestock.',
                icon: Icons.storefront_outlined,
                action: PrimaryButton(
                  label: 'List Item',
                  onPressed: () => _showListDialog(context, ref),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(productsProvider),
                child: ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final p = products[i];
                    return Card(
                      child: ListTile(
                        onTap: () => _showProductDetail(context, ref, p),
                        leading: p.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: p.imageUrl!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => CircleAvatar(
                                    backgroundColor: AppColors.primaryContainer,
                                    child: Text(p.category[0].toUpperCase()),
                                  ),
                                  errorWidget: (_, __, ___) => CircleAvatar(
                                    backgroundColor: AppColors.primaryContainer,
                                    child: Text(p.category[0].toUpperCase()),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.primaryContainer,
                                child: Text(p.category[0].toUpperCase()),
                              ),
                        title: Text(p.name),
                        subtitle: Text('${p.category}${p.description != null ? ' · ${p.description}' : ''}'),
                        trailing: Text('₹${p.price.toStringAsFixed(0)}/${p.unit}',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, WidgetRef ref, Product p) {
    final user = ref.read(currentUserProvider).valueOrNull;
    final phone = p.contactPhone ?? user?.mobile;

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (p.imageUrl != null)
              ClipRRect(
                borderRadius: AppSpacing.cardRadius,
                child: CachedNetworkImage(
                  imageUrl: p.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (p.imageUrl != null) const SizedBox(height: AppSpacing.md),
            Text(p.name, style: Theme.of(ctx).textTheme.titleLarge),
            Text('${p.category} · ₹${p.price.toStringAsFixed(0)}/${p.unit}'),
            if (p.description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(p.description!),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: phone != null ? 'Contact Seller' : 'No contact available',
              onPressed: phone == null
                  ? null
                  : () async {
                      final uri = Uri.parse('tel:$phone');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else if (ctx.mounted) {
                        AppSnackBar.error(ctx, 'Could not open phone dialer');
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _showListDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Machinery');
    final priceCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'day');
    final descCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    var listingType = 'rent';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('List an Item', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'rent', label: Text('Rent')),
                ButtonSegment(value: 'sell', label: Text('Sell')),
              ],
              selected: {listingType},
              onSelectionChanged: (v) => setState(() => listingType = v.first),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Item Name', controller: nameCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Category (Machinery, Livestock, Seeds...)', controller: categoryCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Price', controller: priceCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Unit (day, kg, piece)', controller: unitCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Contact Phone', controller: phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Description', controller: descCtrl),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'List Item',
              onPressed: () async {
                final price = double.tryParse(priceCtrl.text.trim());
                if (nameCtrl.text.isEmpty || price == null) {
                  AppSnackBar.error(ctx, 'Enter name and price');
                  return;
                }
                final user = ref.read(currentUserProvider).valueOrNull;
                final result = await ref.read(homeRepositoryProvider).createProduct(
                      name: nameCtrl.text.trim(),
                      category: categoryCtrl.text.trim(),
                      price: price,
                      unit: unitCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                      listingType: listingType,
                      state: user?.state,
                      contactPhone: phoneCtrl.text.trim().isEmpty ? user?.mobile : phoneCtrl.text.trim(),
                    );
                if (!ctx.mounted) return;
                switch (result) {
                  case Success():
                    Navigator.pop(ctx);
                    ref.invalidate(productsProvider);
                    AppSnackBar.success(context, 'Item listed successfully!');
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
  }
}

/// Crop & soil scan history with export.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(farmHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Export',
            onPressed: () async {
              final storage = await ref.read(localFarmStorageProvider.future);
              await Share.share(storage.exportHistoryCsv(), subject: 'Krishidnya Farm History');
            },
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const EmptyStateWidget(
          title: 'Your farm history',
          subtitle: 'Past crop scans, soil tests, and recommendations appear here.',
          icon: Icons.history_rounded,
        ),
        data: (entries) => entries.isEmpty
            ? const EmptyStateWidget(
                title: 'No history yet',
                subtitle: 'Scan crops or get recommendations to build your history.',
                icon: Icons.history_rounded,
              )
            : ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final e = entries[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        e.type == 'scan'
                            ? Icons.document_scanner_outlined
                            : e.type == 'soil'
                                ? Icons.grass_outlined
                                : Icons.eco_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(e.title),
                      subtitle: Text(e.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text(
                        DateFormat('d MMM').format(e.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/// Farm analytics — digital logbook for crop expenses.
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final cropsAsync = ref.watch(farmCropsProvider);
    final monthlyIncomeAsync = ref.watch(monthlyIncomeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined),
            tooltip: 'Sync to cloud',
            onPressed: () async {
              await syncFarmData(ref);
              if (context.mounted) {
                AppSnackBar.success(context, 'Farm data synced');
              }
            },
          ),
          TextButton.icon(
            onPressed: () => _showAddCropDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Crop'),
          ),
        ],
      ),
      body: cropsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const EmptyStateWidget(
          title: 'Your digital farm notebook',
          subtitle: 'Track sowing, fertilizers, labour, spraying, and harvest costs.',
          icon: Icons.analytics_outlined,
        ),
        data: (crops) => crops.isEmpty
            ? EmptyStateWidget(
                title: 'Your digital farm notebook',
                subtitle:
                    'Track sowing, fertilizers, labour, spraying, and harvest costs. '
                    'Auto-calculate profit and margins per crop.',
                icon: Icons.analytics_outlined,
                action: PrimaryButton(
                  label: 'Add Crop',
                  onPressed: () => _showAddCropDialog(context),
                ),
              )
            : ListView(
                padding: AppSpacing.screenPadding,
                children: [
                  monthlyIncomeAsync.when(
                    data: (income) => Card(
                      color: AppColors.primaryContainer.withValues(alpha: 0.3),
                      child: ListTile(
                        title: const Text('Monthly Income'),
                        subtitle: const Text('This month from harvested crops'),
                        trailing: Text(
                          '₹${income.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...List.generate(crops.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _CropAnalyticsCard(
                        crop: crops[i],
                        onTap: () => _showCropDetail(context, crops[i]),
                        onDelete: () async {
                          final storage =
                              await ref.read(localFarmStorageProvider.future);
                          await storage.deleteCrop(crops[i].id);
                          ref.invalidate(farmCropsProvider);
                          ref.invalidate(monthlyIncomeProvider);
                        },
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  void _showAddCropDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final areaCtrl = TextEditingController(text: '1');
    final dateCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
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
            Text('Add Crop', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Crop Name', controller: nameCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Area (acres)', controller: areaCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Sowing Date (YYYY-MM-DD)', controller: dateCtrl),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Add Crop',
              onPressed: () async {
                final area = double.tryParse(areaCtrl.text.trim()) ?? 1;
                if (nameCtrl.text.isEmpty) {
                  AppSnackBar.error(ctx, 'Enter crop name');
                  return;
                }
                final storage = await ref.read(localFarmStorageProvider.future);
                await storage.addCrop(FarmCrop(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text.trim(),
                  area: area,
                  sowingDate: dateCtrl.text.trim(),
                ));
                ref.invalidate(farmCropsProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCropDetail(BuildContext context, FarmCrop crop) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _CropDetailScreen(crop: crop),
      ),
    );
  }
}

class _CropAnalyticsCard extends StatelessWidget {
  const _CropAnalyticsCard({
    required this.crop,
    required this.onTap,
    required this.onDelete,
  });
  final FarmCrop crop;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryContainer,
          child: Text(crop.name[0].toUpperCase()),
        ),
        title: Text(crop.name),
        subtitle: Text('${crop.area} acres · Sown ${crop.sowingDate}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${crop.totalExpenses.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                if (crop.profit != null)
                  Text(
                    'Profit ₹${crop.profit!.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: crop.profit! >= 0 ? AppColors.primary : AppColors.error,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _CropDetailScreen extends ConsumerStatefulWidget {
  const _CropDetailScreen({required this.crop});
  final FarmCrop crop;

  @override
  ConsumerState<_CropDetailScreen> createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends ConsumerState<_CropDetailScreen> {
  late FarmCrop _crop;

  @override
  void initState() {
    super.initState();
    _crop = widget.crop;
  }

  Future<void> _addExpense() async {
    final typeCtrl = TextEditingController(text: 'Fertilizer');
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final dateCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
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
            Text('Add Expense', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Type (Fertilizer, Labour, Spray, Cultivation)', controller: typeCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Description', controller: descCtrl),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Amount (₹)', controller: amountCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Date', controller: dateCtrl),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Save Expense',
              onPressed: () async {
                final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
                final updated = _crop.copyWith(
                  expenses: [
                    ..._crop.expenses,
                    FarmExpense(
                      type: typeCtrl.text.trim(),
                      date: dateCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      amount: amount,
                    ),
                  ],
                );
                final storage = await ref.read(localFarmStorageProvider.future);
                await storage.updateCrop(updated);
                setState(() => _crop = updated);
                ref.invalidate(farmCropsProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordHarvest() async {
    final sellCtrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record Harvest & Sale'),
        content: AppTextField(
          label: 'Total Selling Value (₹)',
          controller: sellCtrl,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final value = double.tryParse(sellCtrl.text.trim());
              if (value == null) return;
              final updated = _crop.copyWith(
                sellingValue: value,
                harvestDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              );
              final storage = await ref.read(localFarmStorageProvider.future);
              await storage.updateCrop(updated);
              setState(() => _crop = updated);
              ref.invalidate(farmCropsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _crop.expensesByCategory();
    return Scaffold(
      appBar: AppBar(title: Text(_crop.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExpense,
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Card(
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                children: [
                  _SummaryRow('Total Expenses', '₹${_crop.totalExpenses.toStringAsFixed(0)}'),
                  if (_crop.sellingValue != null)
                    _SummaryRow('Selling Value', '₹${_crop.sellingValue!.toStringAsFixed(0)}'),
                  if (_crop.profit != null) ...[
                    _SummaryRow('Profit', '₹${_crop.profit!.toStringAsFixed(0)}'),
                    _SummaryRow('Margin', '${_crop.margin?.toStringAsFixed(1) ?? '—'}%'),
                  ],
                ],
              ),
            ),
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('Expense Breakdown', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: categories.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value,
                      title: e.key,
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (_crop.sellingValue == null)
            PrimaryButton(label: 'Record Harvest & Sale', onPressed: _recordHarvest),
          const SizedBox(height: AppSpacing.lg),
          Text('Expenses', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (_crop.expenses.isEmpty)
            const Text('No expenses recorded yet. Tap Add Expense to log costs.')
          else
            ..._crop.expenses.asMap().entries.map((entry) {
              final index = entry.key;
              final e = entry.value;
              return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    title: Text('${e.type} — ₹${e.amount.toStringAsFixed(0)}'),
                    subtitle: Text('${e.date} · ${e.description}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () async {
                        final updatedExpenses = List<FarmExpense>.from(_crop.expenses)
                          ..removeAt(index);
                        final updated = _crop.copyWith(expenses: updatedExpenses);
                        final storage = await ref.read(localFarmStorageProvider.future);
                        await storage.updateCrop(updated);
                        setState(() => _crop = updated);
                        ref.invalidate(farmCropsProvider);
                        ref.invalidate(monthlyIncomeProvider);
                      },
                    ),
                  ),
                );
            }),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
