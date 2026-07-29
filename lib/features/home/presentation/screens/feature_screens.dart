import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/theme/app_colors.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/feedback/empty_state_widget.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// AI crop recommendation — collects farm inputs for Gemini analysis.
class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  String _soilType = 'Loamy';
  String _season = 'Kharif';
  String _watering = 'Drip';
  final _areaController = TextEditingController(text: '1');
  bool _loading = false;

  static const _soils = ['Loamy', 'Clay', 'Sandy', 'Black', 'Red'];
  static const _seasons = ['Kharif', 'Rabi', 'Zaid'];
  static const _wateringTypes = ['Drip', 'Sprinkler', 'Flood', 'Rain-fed'];

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendations() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackBar.info(
      context,
      'Analyzing soil, weather & location for top crop picks...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Recommendation')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Tell us about your farm',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          _DropdownField(
            label: 'Soil Type',
            value: _soilType,
            items: _soils,
            onChanged: (v) => setState(() => _soilType = v!),
          ),
          const SizedBox(height: AppSpacing.md),
          _DropdownField(
            label: 'Season',
            value: _season,
            items: _seasons,
            onChanged: (v) => setState(() => _season = v!),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Farm Area (acres)',
            controller: _areaController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          _DropdownField(
            label: 'Watering Method',
            value: _watering,
            items: _wateringTypes,
            onChanged: (v) => setState(() => _watering = v!),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Get Top 4 Crops',
            isLoading: _loading,
            icon: Icons.psychology_outlined,
            onPressed: _getRecommendations,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Recommendations include weather analysis, water needs, '
            'days to harvest, and expected profit — powered by Gemini AI.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
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
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
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

  @override
  void dispose() {
    _commodityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final result = await ref.read(homeRepositoryProvider).getMandiPrices(
          commodity: _commodityController.text.trim(),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Mandi Prices')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppTextField(label: 'Crop', controller: _commodityController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'State', controller: _stateController),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Fetch Today\'s Prices',
            isLoading: _loading,
            onPressed: _fetch,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_prices != null)
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Text(_prices.toString()),
              ),
            ),
        ],
      ),
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
            onPressed: () {},
            tooltip: 'List item',
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => EmptyStateWidget(
          title: 'Marketplace',
          subtitle: 'Rent machinery, sell livestock, trade with farmers nearby.',
          icon: Icons.storefront_outlined,
        ),
        data: (products) => products.isEmpty
            ? const EmptyStateWidget(
                title: 'No listings yet',
                subtitle: 'Be the first to list tractors, seeds, or livestock.',
                icon: Icons.storefront_outlined,
              )
            : ListView.separated(
                padding: AppSpacing.screenPadding,
                itemCount: products.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final p = products[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(p.category[0].toUpperCase()),
                      ),
                      title: Text(p.name),
                      subtitle: Text(p.category),
                      trailing: Text('₹${p.price}/${p.unit}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/// Crop & soil scan history.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const EmptyStateWidget(
        title: 'Your farm history',
        subtitle: 'Past crop scans, soil tests, and recommendations appear here.',
        icon: Icons.history_rounded,
      ),
    );
  }
}

/// Farm analytics — digital logbook for crop expenses.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Analytics'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Crop'),
          ),
        ],
      ),
      body: const EmptyStateWidget(
        title: 'Your digital farm notebook',
        subtitle:
            'Track sowing, fertilizers, labour, spraying, and harvest costs. '
            'Auto-calculate profit and margins per crop.',
        icon: Icons.analytics_outlined,
      ),
    );
  }
}
