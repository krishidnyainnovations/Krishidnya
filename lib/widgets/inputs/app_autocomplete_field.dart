import 'package:flutter/material.dart';
import 'package:cropdoc/core/theme/app_colors.dart';
import 'package:cropdoc/core/theme/app_spacing.dart';

/// Autocomplete field with suggestions and quick selection chips
class AppAutocompleteField extends StatefulWidget {
  const AppAutocompleteField({
    required this.label,
    required this.suggestions,
    required this.controller,
    super.key,
    this.hint,
    this.onSelected,
    this.showChips = true,
    this.maxChips = 6,
  });

  final String label;
  final List<String> suggestions;
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onSelected;
  final bool showChips;
  final int maxChips;

  @override
  State<AppAutocompleteField> createState() => _AppAutocompleteFieldState();
}

class _AppAutocompleteFieldState extends State<AppAutocompleteField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displaySuggestions = widget.suggestions.take(widget.maxChips).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        
        // Quick selection chips
        if (widget.showChips && displaySuggestions.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: displaySuggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  widget.controller.text = suggestion;
                  widget.onSelected?.call(suggestion);
                  setState(() {});
                },
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        
        // Text field with autocomplete
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return widget.suggestions.where((String option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            widget.controller.text = selection;
            widget.onSelected?.call(selection);
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Type or select from suggestions',
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onChanged: (value) {
                widget.controller.text = value;
              },
            );
          },
        ),
      ],
    );
  }
}

/// Common expense type suggestions
class ExpenseTypeSuggestions {
  static const List<String> commonTypes = [
    'Fertilizer',
    'Labour',
    'Seeds',
    'Pesticides',
    'Irrigation',
    'Equipment',
    'Transport',
    'Storage',
    'Marketing',
    'Insurance',
    'Land Rent',
    'Electricity',
    'Fuel',
    'Packaging',
    'Laboratory',
  ];
}

/// Common expense description suggestions
class ExpenseDescriptionSuggestions {
  static const Map<String, List<String>> categoryDescriptions = {
    'Fertilizer': [
      'Urea',
      'DAP',
      'NPK',
      'Organic Compost',
      'Vermicompost',
      'Micronutrients',
    ],
    'Labour': [
      'Planting',
      'Harvesting',
      'Weeding',
      'Irrigation',
      'Spraying',
    ],
    'Seeds': [
      'Hybrid Seeds',
      'Organic Seeds',
      'Seed Treatment',
    ],
    'Pesticides': [
      'Fungicides',
      'Insecticides',
      'Herbicides',
      'Bio-pesticides',
    ],
    'Irrigation': [
      'Drip Irrigation',
      'Sprinkler System',
      'Flood Irrigation',
      'Water Pump',
    ],
  };
  
  static List<String> getDescriptionsForType(String? type) {
    if (type == null || !categoryDescriptions.containsKey(type)) {
      return [
        'General Expense',
        'Maintenance',
        'Repair',
        'Purchase',
        'Service',
      ];
    }
    return categoryDescriptions[type]!;
  }
}
