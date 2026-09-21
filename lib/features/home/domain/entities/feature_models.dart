import 'dart:convert';

/// Parsed crop recommendation from Gemini chat response.
class CropRecommendationResult {
  const CropRecommendationResult({
    required this.weatherAnalysis,
    required this.crops,
    this.rawText,
  });

  factory CropRecommendationResult.fromApiResponse(Map<String, dynamic> data) {
    final reply =
        data['response'] as String? ??
        data['message'] as String? ??
        data['content'] as String? ??
        '';

    if (data['weather_analysis'] != null || data['crops'] != null) {
      return CropRecommendationResult.fromJson(data);
    }

    try {
      final start = reply.indexOf('{');
      final end = reply.lastIndexOf('}');
      if (start >= 0 && end > start) {
        final parsed =
            jsonDecode(reply.substring(start, end + 1)) as Map<String, dynamic>;
        return CropRecommendationResult.fromJson(parsed);
      }
    } catch (_) {}

    return CropRecommendationResult(
      weatherAnalysis: const WeatherAnalysis(
        temperature: 'See analysis below',
        humidity: '—',
        expectedRain: '—',
      ),
      crops: [
        RecommendedCrop(
          name: 'AI Recommendation',
          why:
              reply.isNotEmpty ? reply : 'Could not parse structured response.',
        ),
      ],
      rawText: reply,
    );
  }

  factory CropRecommendationResult.fromJson(Map<String, dynamic> json) {
    final analysis = json['weather_analysis'] as Map<String, dynamic>? ?? {};
    final cropsList = json['crops'] as List<dynamic>? ?? [];
    return CropRecommendationResult(
      weatherAnalysis: WeatherAnalysis.fromJson(analysis),
      crops:
          cropsList
              .map((e) => RecommendedCrop.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  final WeatherAnalysis weatherAnalysis;
  final List<RecommendedCrop> crops;
  final String? rawText;
}

class WeatherAnalysis {
  const WeatherAnalysis({
    required this.temperature,
    required this.humidity,
    required this.expectedRain,
  });

  factory WeatherAnalysis.fromJson(Map<String, dynamic> json) =>
      WeatherAnalysis(
        temperature: json['temperature']?.toString() ?? '—',
        humidity: json['humidity']?.toString() ?? '—',
        expectedRain: json['expected_rain']?.toString() ?? '—',
      );

  final String temperature;
  final String humidity;
  final String expectedRain;
}

class RecommendedCrop {
  const RecommendedCrop({
    required this.name,
    required this.why,
    this.waterRequired,
    this.daysToHarvest,
    this.growingPeriod,
    this.expectedProfit,
  });

  factory RecommendedCrop.fromJson(Map<String, dynamic> json) =>
      RecommendedCrop(
        name: json['name'] as String? ?? 'Crop',
        why: json['why'] as String? ?? '',
        waterRequired: json['water_required']?.toString(),
        daysToHarvest: json['days_to_harvest']?.toString(),
        growingPeriod: json['growing_period']?.toString(),
        expectedProfit: json['expected_profit']?.toString(),
      );

  final String name;
  final String why;
  final String? waterRequired;
  final String? daysToHarvest;
  final String? growingPeriod;
  final String? expectedProfit;
}

/// Structured disease scan result.
class ScanCropResult {
  const ScanCropResult({
    required this.disease,
    this.confidence,
    this.organicCure,
    this.chemicalCure,
    this.dosage,
    this.products,
    this.raw,
    this.plantName,
    this.plantType,
    this.healthStatus,
    this.severity,
    this.symptoms,
    this.affectedParts,
    this.treatmentMethods,
    this.prevention,
    // New fields from improved backend schema
    this.diseaseScientificName,
    this.overallCondition,
    this.diseaseDetected,
    this.organicEffectiveness,
    this.chemicalEffectiveness,
    this.homeRemedies,
    this.culturalPractices,
    this.cropRotation,
    this.resistantVarieties,
    this.additionalNotes,
    this.economicImpact,
    this.spreadRisk,
    this.recommendedProducts,
  });

  factory ScanCropResult.fromJson(Map<String, dynamic> json) {
    // Handle improved backend response structure
    final organicTreatment = json['organic_treatment'] as Map<String, dynamic>?;
    final chemicalTreatment =
        json['chemical_treatment'] as Map<String, dynamic>?;
    final prevention = json['prevention'] as Map<String, dynamic>?;

    // Extract organic cure methods
    var organicMethods = <String>[];
    if (organicTreatment != null) {
      if (organicTreatment['methods'] is List) {
        organicMethods =
            (organicTreatment['methods'] as List<dynamic>)
                .map((e) => e.toString())
                .toList();
      }
      if (organicTreatment['home_remedies'] is List) {
        organicMethods.addAll(
          (organicTreatment['home_remedies'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
        );
      }
    }

    // Extract chemical fungicides with dosage information
    var chemicalFungicides = <String>[];
    if (chemicalTreatment != null && chemicalTreatment['fungicides'] is List) {
      chemicalFungicides =
          (chemicalTreatment['fungicides'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
    }

    // Extract symptoms
    var symptomsList = <String>[];
    if (json['symptoms'] is List) {
      symptomsList =
          (json['symptoms'] as List<dynamic>).map((e) => e.toString()).toList();
    }

    // Extract affected parts
    var affectedPartsList = <String>[];
    if (json['affected_parts'] is List) {
      affectedPartsList =
          (json['affected_parts'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
    }

    // Extract prevention methods
    final preventionMethods = <String>[];
    if (prevention != null) {
      if (prevention['cultural_practices'] is List) {
        preventionMethods.addAll(
          (prevention['cultural_practices'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
        );
      }
      if (prevention['resistant_varieties'] is List) {
        preventionMethods.addAll(
          (prevention['resistant_varieties'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
        );
      }
    }

    // Extract recommended products with confidence
    final recommendedProductsList = <RecommendedProduct>[];
    if (chemicalTreatment != null && chemicalTreatment['fungicides'] is List) {
      final fungicides = chemicalTreatment['fungicides'] as List<dynamic>;
      for (final fungicide in fungicides) {
        if (fungicide is String) {
          recommendedProductsList.add(
            RecommendedProduct(
              name: fungicide,
              dosage: chemicalTreatment['tank_mix_compatibility'] as String?,
              confidence: double.tryParse(
                json['confidence']?.toString() ?? '0',
              ),
            ),
          );
        }
      }
    }

    return ScanCropResult(
      disease:
          json['disease_name'] as String? ??
          json['disease'] as String? ??
          json['diagnosis'] as String? ??
          json['condition'] as String? ??
          'Analysis Result',
      confidence:
          json['confidence'] as String? ?? json['confidence_score']?.toString(),
      organicCure: organicMethods.isNotEmpty ? organicMethods.join(', ') : null,
      chemicalCure:
          chemicalFungicides.isNotEmpty ? chemicalFungicides.join(', ') : null,
      dosage: chemicalTreatment?['tank_mix_compatibility'] as String?,
      products:
          chemicalFungicides.isNotEmpty ? chemicalFungicides.join(', ') : null,
      plantName: json['plant_name'] as String?,
      plantType: json['plant_type'] as String?,
      healthStatus: json['health_status'] as String?,
      severity: json['severity'] as String?,
      symptoms: symptomsList,
      affectedParts: affectedPartsList,
      treatmentMethods: organicMethods,
      prevention: preventionMethods,
      raw: json,
      // New fields from improved backend schema
      diseaseScientificName: json['disease_scientific_name'] as String?,
      overallCondition: json['overall_condition'] as String?,
      diseaseDetected: json['disease_detected'] as bool?,
      organicEffectiveness: organicTreatment?['effectiveness'] as String?,
      chemicalEffectiveness: chemicalTreatment?['effectiveness'] as String?,
      homeRemedies:
          (organicTreatment?['home_remedies'] as List<dynamic>?)
              ?.cast<String>(),
      culturalPractices:
          (prevention?['cultural_practices'] as List<dynamic>?)?.cast<String>(),
      cropRotation: prevention?['crop_rotation'] as String?,
      resistantVarieties:
          (prevention?['resistant_varieties'] as List<dynamic>?)
              ?.cast<String>(),
      additionalNotes: json['additional_notes'] as String?,
      economicImpact: json['economic_impact'] as String?,
      spreadRisk: json['spread_risk'] as String?,
      recommendedProducts: recommendedProductsList,
    );
  }

  final String disease;
  final String? confidence;
  final String? organicCure;
  final String? chemicalCure;
  final String? dosage;
  final String? products;
  final String? plantName;
  final String? plantType;
  final String? healthStatus;
  final String? severity;
  final List<String>? symptoms;
  final List<String>? affectedParts;
  final List<String>? treatmentMethods;
  final List<String>? prevention;
  final Map<String, dynamic>? raw;

  // New fields from improved backend schema
  final String? diseaseScientificName;
  final String? overallCondition;
  final bool? diseaseDetected;
  final String? organicEffectiveness;
  final String? chemicalEffectiveness;
  final List<String>? homeRemedies;
  final List<String>? culturalPractices;
  final String? cropRotation;
  final List<String>? resistantVarieties;
  final String? additionalNotes;
  final String? economicImpact;
  final String? spreadRisk;
  final List<RecommendedProduct>? recommendedProducts;
}

/// Recommended product with dosage and confidence information
class RecommendedProduct {
  const RecommendedProduct({required this.name, this.dosage, this.confidence});

  final String name;
  final String? dosage;
  final double? confidence;
}

/// In-app notification from backend.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.type,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id']?.toString() ?? '',
        title: json['title'] as String? ?? 'Notification',
        body: json['body'] as String? ?? json['message'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
        isRead: json['is_read'] as bool? ?? false,
        type: json['type'] as String?,
      );

  final String id;
  final String title;
  final String body;
  final String createdAt;
  final bool isRead;
  final String? type;

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    title: title,
    body: body,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
    type: type,
  );
}

/// Nearby farmer profile.
class NearbyFarmer {
  const NearbyFarmer({
    required this.id,
    required this.name,
    this.location,
    this.distanceKm,
    this.mobile,
  });

  factory NearbyFarmer.fromJson(Map<String, dynamic> json) => NearbyFarmer(
    id: json['id']?.toString() ?? '',
    name:
        json['full_name'] as String? ?? json['username'] as String? ?? 'Farmer',
    location: json['location'] as String? ?? json['city'] as String?,
    distanceKm: (json['distance_km'] as num?)?.toDouble(),
    mobile: json['mobile'] as String?,
  );

  final String id;
  final String name;
  final String? location;
  final double? distanceKm;
  final String? mobile;
}

/// Post comment.
class PostComment {
  const PostComment({
    required this.id,
    required this.content,
    required this.authorName,
    required this.createdAt,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return PostComment(
      id: json['id']?.toString() ?? '',
      content: json['content'] as String? ?? '',
      authorName:
          author?['full_name'] as String? ??
          author?['username'] as String? ??
          'Farmer',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  final String id;
  final String content;
  final String authorName;
  final String createdAt;
}
