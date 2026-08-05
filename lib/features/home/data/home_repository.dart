import 'package:dio/dio.dart';
import 'package:krishidnya/core/api/api_config.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/network/api_client.dart';
import 'package:krishidnya/core/services/app_logger.dart';
import 'package:krishidnya/features/home/data/local_farm_storage.dart';
import 'package:krishidnya/features/home/domain/entities/feature_models.dart';
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

  Future<Scheme> fetchScheme(int id) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConfig.schemeDetail(id),
    );
    return Scheme.fromJson(response.data ?? {});
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
    bool includeForecast = true,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.weather,
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'units': 'metric',
        'forecast_days': 15,
        'include_forecast': includeForecast,
      },
    );

    final data = response.data ?? {};
    data['location'] = locationLabel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    _logger.info('Weather', 'Fetched weather for $locationLabel');
    return WeatherSummary.fromJson(data);
  }

  Future<List<WeatherSummary>> fetchWeatherBatch(
    List<Map<String, dynamic>> locations,
  ) async {
    final response = await _client.post<List<dynamic>>(
      ApiConfig.weatherBatch,
      data: {'locations': locations},
    );
    return (response.data ?? [])
        .map((e) => WeatherSummary.fromJson(e as Map<String, dynamic>))
        .toList();
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

  Future<Map<String, dynamic>> fetchSoilData({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.soil,
      data: {'latitude': latitude, 'longitude': longitude},
    );
    return response.data ?? {};
  }

  Future<List<Product>> fetchProducts({
    String? category,
    String? search,
    String? state,
  }) async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.products,
      queryParameters: {
        if (category != null) 'category': category,
        if (search != null) 'search': search,
        if (state != null) 'state': state,
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

  Future<Map<String, dynamic>> likePost(int postId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.postLike(postId),
    );
    return response.data ?? {};
  }

  Future<List<PostComment>> fetchComments(int postId) async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.postComments(postId),
    );
    return (response.data ?? [])
        .map((e) => PostComment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PostComment> addComment(int postId, String content) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.postComments(postId),
      data: {'content': content},
    );
    return PostComment.fromJson(response.data ?? {});
  }

  Future<List<NearbyFarmer>> fetchNearbyUsers({
    double? latitude,
    double? longitude,
    double radiusKm = 50,
  }) async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.nearbyUsers,
      queryParameters: {
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'radius_km': radiusKm,
      },
    );
    return (response.data ?? [])
        .map((e) => NearbyFarmer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AppNotification>> fetchNotifications() async {
    final response = await _client.get<List<dynamic>>(
      ApiConfig.notifications,
    );
    return (response.data ?? [])
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FarmCrop>> fetchFarmCropsFromServer() async {
    final response = await _client.get<List<dynamic>>(ApiConfig.farmCrops);
    return (response.data ?? [])
        .map((e) => FarmCrop.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> syncFarmCropsToServer(List<FarmCrop> crops) async {
    await _client.post<Map<String, dynamic>>(
      ApiConfig.farmCrops,
      data: {'crops': crops.map((c) => c.toJson()).toList()},
    );
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

  Future<Map<String, dynamic>> scanCrop({required FormData formData}) async {
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
    String? imagePath,
  }) async {
    if (imagePath != null) {
      final formData = FormData.fromMap({
        'content': content,
        if (title != null) 'title': title,
        'category': category,
        'file': await MultipartFile.fromFile(imagePath),
      });
      final response = await _client.multipart<Map<String, dynamic>>(
        ApiConfig.posts,
        formData: formData,
      );
      return response.data ?? {};
    }

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
    String listingType = 'sell',
    String? state,
    String? contactPhone,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConfig.products,
      data: {
        'name': name,
        'category': category,
        'price': price,
        'unit': unit,
        'listing_type': listingType,
        if (description != null) 'description': description,
        if (state != null) 'state': state,
        if (contactPhone != null) 'contact_phone': contactPhone,
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

  Future<Result<Scheme>> getScheme(int id) async {
    try {
      return Success(await _remote.fetchScheme(id));
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
    bool includeForecast = true,
  }) async {
    try {
      return Success(await _remote.fetchWeather(
        latitude: latitude,
        longitude: longitude,
        locationLabel: locationLabel,
        includeForecast: includeForecast,
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

  Future<Result<Map<String, dynamic>>> getSoilData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return Success(await _remote.fetchSoilData(
        latitude: latitude,
        longitude: longitude,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<Product>>> getProducts({String? state}) async {
    try {
      return Success(await _remote.fetchProducts(state: state));
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

  Future<Result<Map<String, dynamic>>> likePost(int postId) async {
    try {
      return Success(await _remote.likePost(postId));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<PostComment>>> getComments(int postId) async {
    try {
      return Success(await _remote.fetchComments(postId));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<PostComment>> addComment(int postId, String content) async {
    try {
      return Success(await _remote.addComment(postId, content));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<NearbyFarmer>>> getNearbyUsers({
    double? latitude,
    double? longitude,
  }) async {
    try {
      return Success(await _remote.fetchNearbyUsers(
        latitude: latitude,
        longitude: longitude,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      return Success(await _remote.fetchNotifications());
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<bool>> syncFarmCrops(List<FarmCrop> crops) async {
    try {
      await _remote.syncFarmCropsToServer(crops);
      return const Success(true);
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<List<FarmCrop>>> fetchRemoteFarmCrops() async {
    try {
      return Success(await _remote.fetchFarmCropsFromServer());
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

  Future<Result<CropRecommendationResult>> getCropRecommendations({
    required String soilType,
    required String season,
    required String watering,
    required double area,
    required String location,
    String? weatherSummary,
    String? soilApiData,
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
${soilApiData != null ? '- Soil API data: $soilApiData' : ''}
''';

    try {
      final data = await _remote.sendChatMessage(message: prompt);
      return Success(CropRecommendationResult.fromApiResponse(data));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }

  Future<Result<Map<String, dynamic>>> createPost({
    required String content,
    String? title,
    String category = 'Discussion',
    String? imagePath,
  }) async {
    try {
      return Success(await _remote.createPost(
        content: content,
        title: title,
        category: category,
        imagePath: imagePath,
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
    String listingType = 'sell',
    String? state,
    String? contactPhone,
  }) async {
    try {
      return Success(await _remote.createProduct(
        name: name,
        category: category,
        price: price,
        unit: unit,
        description: description,
        listingType: listingType,
        state: state,
        contactPhone: contactPhone,
      ));
    } catch (e) {
      return ErrorResult(ExceptionMapper.map(e));
    }
  }
}

/// Parses mandi price API responses with flexible backend shapes.
List<Map<String, dynamic>> parseMandiRecords(Map<String, dynamic> data) {
  if (data.containsKey('error')) return [];
  if (data['records'] is List) {
    return (data['records'] as List).cast<Map<String, dynamic>>();
  }
  if (data['data'] is List) {
    return (data['data'] as List).map((e) {
      if (e is Map<String, dynamic>) return e;
      return <String, dynamic>{'price': e.toString()};
    }).toList();
  }
  if (data['prices'] is List) {
    return (data['prices'] as List).cast<Map<String, dynamic>>();
  }
  return [data];
}
