import 'package:dio/dio.dart';
import 'package:krishidnya/core/api/api_config.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/network/api_client.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/features/home/domain/entities/home_entities.dart';

/// Remote API calls for home screen features.
class HomeRemoteDataSource {
  HomeRemoteDataSource({
    required ApiClient apiClient,
    AppLogger? logger,
  })  : _client = apiClient,
        _logger = logger ?? AppLogger.instance;

  final ApiClient _client;
  final AppLogger _logger;

  Future<List<Scheme>> fetchSchemes({String? search, String? type}) async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.schemes,
      queryParameters: {
        if (search != null) 'search': search,
        if (type != null) 'type': type,
      },
    );
    return (response.data ?? [])
        .map((e) => Scheme.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> applyForScheme({
    required int schemeId,
    required String name,
    required String mobile,
    required String villageName,
    int? userId,
  }) async {
    await _client.post<Map<String, dynamic>>(
      ApiConfig.schemeInterests,
      data: {
        'scheme_id': schemeId,
        'name': name,
        'mobile_no': mobile,
        'village_name': villageName,
        if (userId != null) 'user_id': userId,
      },
    );
  }

  Future<WeatherSummary> fetchWeather({
    required double latitude,
    required double longitude,
    String locationLabel = 'Your Farm',
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.weather,
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'units': 'metric',
      },
    );

    final data = response.data ?? {};
    data['location'] = locationLabel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    _logger.info('Weather', 'Fetched weather for $locationLabel');
    return WeatherSummary.fromJson(data);
  }

  Future<Map<String, dynamic>> fetchMandiPrices({
    String? commodity,
    String? state,
    String? district,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.cropPrices,
      data: {
        if (commodity != null) 'commodity': commodity,
        if (state != null) 'state': state,
        if (district != null) 'district': district,
      },
    );
    return response.data ?? {};
  }

  Future<List<Product>> fetchProducts({String? category, String? search}) async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.products,
      queryParameters: {
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );
    return (response.data ?? [])
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CommunityPost>> fetchPosts({String? category}) async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.posts,
      queryParameters: {if (category != null) 'category': category},
    );
    return (response.data ?? [])
        .map((e) => CommunityPost.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> sendChatMessage({
    required String message,
    List<Map<String, String>>? history,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.chat,
      data: {
        'message': message,
        'conversation_history': history ?? [],
        'model': 'gemini',
      },
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> scanCrop({
    required FormData formData,
  }) async {
    final response = await _client.multipart<Map<String, dynamic>>(
      ApiConfig.scanCrop,
      formData: formData,
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createPost({
    required String content,
    String? title,
    String category = 'Discussion',
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.posts,
      data: {
        'content': content,
        if (title != null) 'title': title,
        'category': category,
      },
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createProduct({
    required String name,
    required String category,
    required double price,
    required String unit,
    String? description,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.products,
      data: {
        'name': name,
        'category': category,
        'price': price,
        'unit': unit,
        if (description != null) 'description': description,
      },
    );
    return response.data ?? {};
  }
}

/// Repository wrapping home data source with error mapping.
class HomeRepository {
  HomeRepository({required HomeRemoteDataSource remote}) : _remote = remote;

  final HomeRemoteDataSource _remote;

  Future<Result<List<Scheme>>> getSchemes() async {
    try {
      return Success(await _remote.fetchSchemes());
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<bool>> applyScheme({
    required int schemeId,
    required String name,
    required String mobile,
    required String villageName,
    int? userId,
  }) async {
    try {
      await _remote.applyForScheme(
        schemeId: schemeId,
        name: name,
        mobile: mobile,
        villageName: villageName,
        userId: userId,
      );
      return const Success(true);
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<WeatherSummary>> getWeather({
    required double latitude,
    required double longitude,
    String locationLabel = 'Your Farm',
  }) async {
    try {
      return Success(await _remote.fetchWeather(
        latitude: latitude,
        longitude: longitude,
        locationLabel: locationLabel,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> getMandiPrices({
    String? commodity,
    String? state,
    String? district,
  }) async {
    try {
      return Success(await _remote.fetchMandiPrices(
        commodity: commodity,
        state: state,
        district: district,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<Product>>> getProducts() async {
    try {
      return Success(await _remote.fetchProducts());
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<CommunityPost>>> getPosts() async {
    try {
      return Success(await _remote.fetchPosts());
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> chat(
    String message, {
    List<Map<String, String>>? history,
  }) async {
    try {
      return Success(await _remote.sendChatMessage(
        message: message,
        history: history,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> scanCropImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      return Success(await _remote.scanCrop(formData: formData));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> getCropRecommendations({
    required String soilType,
    required String season,
    required String watering,
    required double area,
    required String location,
    String? weatherSummary,
  }) async {
    final prompt = '''
You are an expert agricultural advisor for Indian farmers.
Based on the following farm data, recommend exactly 4 crops suitable for this farmer.
Respond ONLY with valid JSON (no markdown) in this format:
{
  "weather_analysis": {"temperature": "...", "humidity": "...", "expected_rain": "..."},
  "crops": [
    {
      "name": "Crop Name",
      "why": "Why grow this crop",
      "water_required": "...",
      "days_to_harvest": "...",
      "growing_period": "...",
      "expected_profit": "..."
    }
  ]
}

Farm data:
- Soil type: $soilType
- Season: $season
- Watering method: $watering
- Farm area: $area acres
- Location: $location
${weatherSummary != null ? '- Current weather: $weatherSummary' : ''}
''';

    try {
      return Success(await _remote.sendChatMessage(message: prompt));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> createPost({
    required String content,
    String? title,
    String category = 'Discussion',
  }) async {
    try {
      return Success(await _remote.createPost(
        content: content,
        title: title,
        category: category,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> createProduct({
    required String name,
    required String category,
    required double price,
    required String unit,
    String? description,
  }) async {
    try {
      return Success(await _remote.createProduct(
        name: name,
        category: category,
        price: price,
        unit: unit,
        description: description,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }
}
