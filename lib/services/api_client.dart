import 'package:dio/dio.dart';

class ApiClient {
  // --- Singleton Setup ---
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  // --- Dio Instance ---
  late final Dio dio;

  // --- Initialization ---
  // A flag to ensure this is only run once.
  bool _isInitialized = false;

  /// Configures and initializes the Dio instance.
  /// MUST be called once in main.dart before the app runs.
  void initialize() {
    if (_isInitialized) {
      return; // Already initialized
    }

    dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:5000/api/v1/', // Use your actual base URL
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging, auth tokens, etc.
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => print("DIO LOG: $object"),
      ),
    );

    _isInitialized = true;
  }
}
