import 'package:equatable/equatable.dart';

/// Government scheme from backend.
class Scheme extends Equatable {
  const Scheme({
    required this.id,
    required this.title,
    required this.description,
    required this.schemeType,
    required this.isActive,
    this.eligibilityCriteria,
    this.benefits,
    this.howToApply,
    this.imageUrl,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) => Scheme(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        schemeType: json['scheme_type'] as String? ?? 'General',
        isActive: json['is_active'] as bool? ?? true,
        eligibilityCriteria: json['eligibility_criteria'] as String?,
        benefits: json['benefits'] as String?,
        howToApply: json['how_to_apply'] as String?,
        imageUrl: json['image_url'] as String?,
      );

  final int id;
  final String title;
  final String description;
  final String schemeType;
  final bool isActive;
  final String? eligibilityCriteria;
  final String? benefits;
  final String? howToApply;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, title, description, schemeType, isActive];
}

/// Weather summary for home banner.
class WeatherSummary extends Equatable {
  const WeatherSummary({
    required this.temperature,
    required this.condition,
    required this.location,
    this.humidity,
    this.windSpeed,
    this.icon,
    this.forecast = const [],
    this.latitude,
    this.longitude,
  });

  factory WeatherSummary.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? json;
    final main = current['main'] as Map<String, dynamic>? ?? current;
    final weatherList = current['weather'] as List<dynamic>?;
    final condition = weatherList?.isNotEmpty ?? false
        ? (weatherList!.first as Map)['description'] as String? ?? 'Clear'
        : json['condition'] as String? ?? 'Clear';

    return WeatherSummary(
      temperature: '${(main['temp'] as num?)?.round() ?? json['temperature'] ?? '--'}°C',
      condition: condition,
      location: json['location'] as String? ?? json['name'] as String? ?? 'Your Farm',
      humidity: main['humidity'] != null ? '${main['humidity']}%' : null,
      windSpeed: current['wind'] != null
          ? '${((current['wind'] as Map)['speed'] as num?)?.toStringAsFixed(1)} m/s'
          : null,
      forecast: (json['forecast'] as List<dynamic>?)
              ?.map((e) => ForecastDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  final String temperature;
  final String condition;
  final String location;
  final String? humidity;
  final String? windSpeed;
  final String? icon;
  final List<ForecastDay> forecast;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props =>
      [temperature, condition, location, humidity, windSpeed];
}

class ForecastDay extends Equatable {
  const ForecastDay({
    required this.date,
    required this.high,
    required this.low,
    required this.condition,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) => ForecastDay(
        date: json['date'] as String? ?? json['dt_txt'] as String? ?? '',
        high: '${(json['high'] as num?)?.round() ?? (json['temp_max'] as num?)?.round() ?? '--'}°',
        low: '${(json['low'] as num?)?.round() ?? (json['temp_min'] as num?)?.round() ?? '--'}°',
        condition: json['condition'] as String? ??
            json['description'] as String? ??
            'Clear',
      );

  final String date;
  final String high;
  final String low;
  final String condition;

  @override
  List<Object?> get props => [date, high, low, condition];
}

/// Marketplace product.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    this.description,
    this.inStock = true,
    this.rating = 0,
    this.imageUrl,
    this.contactPhone,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        unit: json['unit'] as String? ?? '',
        description: json['description'] as String?,
        inStock: json['inStock'] as bool? ?? json['in_stock'] as bool? ?? true,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        imageUrl: json['image_url'] as String?,
        contactPhone: json['contact_phone'] as String? ??
            json['contactPhone'] as String?,
      );

  final int id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final String? description;
  final bool inStock;
  final double rating;
  final String? imageUrl;
  final String? contactPhone;

  @override
  List<Object?> get props => [id, name, category, price];
}

/// Community post.
class CommunityPost extends Equatable {
  const CommunityPost({
    required this.id,
    required this.content,
    required this.category,
    required this.authorName,
    required this.createdAt,
    this.title,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.imageUrl,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return CommunityPost(
      id: json['id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? 'Discussion',
      authorName: author?['full_name'] as String? ??
          author?['username'] as String? ??
          'Farmer',
      createdAt: json['created_at'] as String? ?? '',
      title: json['title'] as String?,
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }

  final int id;
  final String content;
  final String category;
  final String authorName;
  final String createdAt;
  final String? title;
  final int likesCount;
  final int commentsCount;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, content, authorName];
}
