import 'dart:convert';

import 'package:cropdoc/core/storage/preferences_service.dart';

/// A single expense entry in the farm logbook.
class FarmExpense {
  FarmExpense({
    required this.type,
    required this.date,
    required this.description,
    required this.amount,
  });

  factory FarmExpense.fromJson(Map<String, dynamic> json) => FarmExpense(
        type: json['type'] as String? ?? '',
        date: json['date'] as String? ?? '',
        description: json['description'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
      );

  final String type;
  final String date;
  final String description;
  final double amount;

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date,
        'description': description,
        'amount': amount,
      };
}

/// A crop tracked in farm analytics.
class FarmCrop {
  FarmCrop({
    required this.id,
    required this.name,
    required this.area,
    required this.sowingDate,
    this.expenses = const [],
    this.sellingValue,
    this.harvestDate,
  });

  factory FarmCrop.fromJson(Map<String, dynamic> json) => FarmCrop(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        area: (json['area'] as num?)?.toDouble() ?? 0,
        sowingDate: json['sowingDate'] as String? ?? '',
        expenses: (json['expenses'] as List<dynamic>?)
                ?.map((e) => FarmExpense.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        sellingValue: (json['sellingValue'] as num?)?.toDouble(),
        harvestDate: json['harvestDate'] as String?,
      );

  final String id;
  final String name;
  final double area;
  final String sowingDate;
  final List<FarmExpense> expenses;
  final double? sellingValue;
  final String? harvestDate;

  double get totalExpenses =>
      expenses.fold(0, (sum, e) => sum + e.amount);

  double? get profit =>
      sellingValue != null ? sellingValue! - totalExpenses : null;

  double? get margin =>
      profit != null && totalExpenses > 0 ? (profit! / totalExpenses) * 100 : null;

  /// Monthly income based on harvest date and selling value.
  double? monthlyIncome(DateTime referenceMonth) {
    if (sellingValue == null) return null;
    final saleDate = DateTime.tryParse(harvestDate ?? '');
    if (saleDate == null) return null;
    if (saleDate.year == referenceMonth.year &&
        saleDate.month == referenceMonth.month) {
      return sellingValue;
    }
    return null;
  }

  Map<String, double> expensesByCategory() {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.type] = (map[e.type] ?? 0) + e.amount;
    }
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'area': area,
        'sowingDate': sowingDate,
        'expenses': expenses.map((e) => e.toJson()).toList(),
        'sellingValue': sellingValue,
        'harvestDate': harvestDate,
      };

  FarmCrop copyWith({
    String? id,
    String? name,
    double? area,
    String? sowingDate,
    List<FarmExpense>? expenses,
    double? sellingValue,
    String? harvestDate,
    bool clearSellingValue = false,
    bool clearHarvestDate = false,
  }) =>
      FarmCrop(
        id: id ?? this.id,
        name: name ?? this.name,
        area: area ?? this.area,
        sowingDate: sowingDate ?? this.sowingDate,
        expenses: expenses ?? this.expenses,
        sellingValue: clearSellingValue ? null : (sellingValue ?? this.sellingValue),
        harvestDate: clearHarvestDate ? null : (harvestDate ?? this.harvestDate),
      );
}

/// Soil test history entry.
class SoilHistoryEntry {
  SoilHistoryEntry({
    required this.id,
    required this.soilType,
    required this.location,
    required this.summary,
    required this.createdAt,
  });

  factory SoilHistoryEntry.fromJson(Map<String, dynamic> json) =>
      SoilHistoryEntry(
        id: json['id'] as String? ?? '',
        soilType: json['soilType'] as String? ?? '',
        location: json['location'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  final String id;
  final String soilType;
  final String location;
  final String summary;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'soilType': soilType,
        'location': location,
        'summary': summary,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// History entry for scans and recommendations.
class HistoryEntry {
  HistoryEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.createdAt,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? '',
        title: json['title'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  final String id;
  final String type;
  final String title;
  final String summary;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'summary': summary,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Local persistence for farm analytics and history.
class LocalFarmStorage {
  LocalFarmStorage(this._prefs);

  final PreferencesService _prefs;

  static const _cropsKey = 'farm_crops';
  static const _historyKey = 'farm_history';
  static const _soilHistoryKey = 'soil_history';

  List<FarmCrop> getCrops() {
    final raw = _prefs.getString(_cropsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => FarmCrop.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCrops(List<FarmCrop> crops) async {
    await _prefs.setString(
      _cropsKey,
      jsonEncode(crops.map((c) => c.toJson()).toList()),
    );
  }

  Future<void> addCrop(FarmCrop crop) async {
    final crops = getCrops()..add(crop);
    await saveCrops(crops);
  }

  Future<void> updateCrop(FarmCrop crop) async {
    final crops = getCrops();
    final index = crops.indexWhere((c) => c.id == crop.id);
    if (index >= 0) {
      crops[index] = crop;
      await saveCrops(crops);
    }
  }

  Future<void> deleteCrop(String id) async {
    final crops = getCrops()..removeWhere((c) => c.id == id);
    await saveCrops(crops);
  }

  List<HistoryEntry> getHistory() {
    final raw = _prefs.getString(_historyKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addHistory(HistoryEntry entry) async {
    final history = getHistory()..insert(0, entry);
    await _prefs.setString(
      _historyKey,
      jsonEncode(history.map((e) => e.toJson()).toList()),
    );
  }

  List<SoilHistoryEntry> getSoilHistory() {
    final raw = _prefs.getString(_soilHistoryKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => SoilHistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addSoilHistory(SoilHistoryEntry entry) async {
    final history = getSoilHistory()..insert(0, entry);
    await _prefs.setString(
      _soilHistoryKey,
      jsonEncode(history.map((e) => e.toJson()).toList()),
    );
  }

  /// Combined timeline of scans, recommendations, and soil tests.
  List<HistoryEntry> getUnifiedHistory() {
    final entries = getHistory();
    final soil = getSoilHistory().map(
      (s) => HistoryEntry(
        id: s.id,
        type: 'soil',
        title: 'Soil: ${s.soilType}',
        summary: s.summary,
        createdAt: s.createdAt,
      ),
    );
    return [...entries, ...soil]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Total monthly income from harvested crops in given month.
  double monthlyIncome(DateTime month) {
    return getCrops().fold(0, (sum, crop) {
      return sum + (crop.monthlyIncome(month) ?? 0);
    });
  }

  String exportHistoryCsv() {
    final buffer = StringBuffer('Type,Title,Summary,Date\n');
    for (final e in getUnifiedHistory()) {
      buffer.writeln(
        '${e.type},"${e.title}","${e.summary}",${e.createdAt.toIso8601String()}',
      );
    }
    return buffer.toString();
  }
}
