import 'dart:convert';

/// Parsed crop recommendation from Gemini chat response.
class CropRecommendationResult {
  const CropRecommendationResult({
    required this.weatherAnalysis,
    required this.crops,
    this.rawText,
  });

  factory CropRecommendationResult.fromApiResponse(Map<String, dynamic> data) {
    final reply = data['response'] as String? ??
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
          why: reply.isNotEmpty
              ? reply
              : 'Could not parse structured response.',
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
      crops: cropsList
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
  });

  factory ScanCropResult.fromJson(Map<String, dynamic> json) {
    final organic = json['organic_cure'] as String? ??
        json['organic_treatment'] as String?;
    final chemical = json['chemical_cure'] as String? ??
        json['chemical_treatment'] as String?;

    return ScanCropResult(
      disease: json['disease'] as String? ??
          json['diagnosis'] as String? ??
          json['condition'] as String? ??
          'Analysis Result',
      confidence: json['confidence'] as String? ??
          json['confidence_score']?.toString(),
      organicCure: organic,
      chemicalCure: chemical,
      dosage: json['dosage'] as String? ?? json['dosage_per_ltr'] as String?,
      products: json['recommended_products'] as String? ??
          json['products']?.toString(),
      raw: json,
    );
  }

  final String disease;
  final String? confidence;
  final String? organicCure;
  final String? chemicalCure;
  final String? dosage;
  final String? products;
  final Map<String, dynamic>? raw;
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
        name: json['full_name'] as String? ??
            json['username'] as String? ??
            'Farmer',
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
      authorName: author?['full_name'] as String? ??
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
