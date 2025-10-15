import 'dart:async';
import 'dart:convert';
import 'dart:io';
// Import Dio instead of http
import 'package:dio/dio.dart';
import 'package:parentee_fe/features/auth/models/api_response.dart';

class ApiService {
  // Use a final Dio instance for better management and interceptors
  static final Dio _dio = Dio();
  static const String baseUrl = 'http://localhost:5000/api/v1';
  // static const String baseUrl = 'http://10.0.2.2:5000/api/v1';

  // Static constructor to configure Dio (optional, but good practice)
  static void configureDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10); // 10s
    _dio.options.receiveTimeout = const Duration(seconds: 10); // 10s
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // You can add interceptors here, e.g., for logging or token refresh
    // _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // Initialize configuration (call this once in your app's main or setup)
  // static { // This is for Dart 3, use a method for compatibility
  //   configureDio();
  // }

  // Call configureDio() outside the class once, or make the methods call it if needed.

  // --------------------------
  // 🔹 API Endpoints (Minimal changes here)
  // --------------------------

  static Future<ApiResponse> login(String email, String password) async {
    return await _sendRequest(
      'auth/login',
      method: 'POST',
      data: {'email': email, 'password': password},
    );
  }

  static Future<ApiResponse> register(
      String email, String fullName, String phone, String password) async {
    return await _sendRequest(
      'user',
      method: 'POST',
      data: {
        'email': email,
        'fullName': fullName,
        'phone': phone,
        'password': password,
      },
    );
  }

  static Future<ApiResponse> signInWithGoogle(
      String email, String fullName) async {
    return await _sendRequest(
      'auth/signin-google',
      method: 'POST',
      data: {'email': email, 'fullName': fullName},
    );
  }

  static Future<ApiResponse> getUserProfile(String token) async {
    return await _sendRequest(
      'user/current',
      token: token,
      method: 'GET',
    );
  }

  /// 🔹 Generic request handler using Dio
  static Future<ApiResponse> _sendRequest(
    String endpoint, {
    String method = 'GET',
    String? token,
    Map<String, dynamic>? data, // Renamed 'body' to 'data' for Dio convention
  }) async {
    print('Call API with endpoint: $baseUrl/$endpoint');

    // Create a temporary Options object to apply the token
    final options = Options(
      headers: {
        // Inherit default headers from _dio.options if configured,
        // or explicitly set content type if not configured globally.
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      method: method, // Set the HTTP method
    );

    try {
      Response response;

      // Dio handles method and data/body in a unified way
      // The endpoint is appended to the baseUrl set in Dio options
      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(endpoint, data: data, options: options);
          break;
        case 'PUT':
          response = await _dio.put(endpoint, data: data, options: options);
          break;
        case 'DELETE':
          response = await _dio.delete(endpoint, data: data, options: options);
          break;
        case 'GET':
        default:
          // For GET, the data parameter is typically used for query parameters,
          // but if you have a configured Dio instance, a simple call works.
          response = await _dio.get(endpoint, options: options);
      }

      // Dio automatically parses the response body into the 'data' field
      // if the Content-Type is application/json. The status code is in 'statusCode'.

      // 🔹 Parse successful response
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Dio's response.data is already the decoded JSON map
        final Map<String, dynamic> jsonBody =
            response.data is Map ? response.data : {};
        return ApiResponse(success: true, data: jsonBody['data']);
      } else {
        // This block is often unnecessary because Dio throws a DioException
        // for non-2xx status codes (unless validateStatus is overridden).
        final jsonBody = response.data is Map ? response.data : {};
        final message = jsonBody['reason'] ??
            jsonBody['message'] ??
            'Request failed (${response.statusCode})';
        return ApiResponse(success: false, message: message);
      }
    } on DioException catch (e) {
      // DioException handles all Dio-specific errors (HTTP errors, timeouts, network issues)
      return _handleDioError(e);
    } catch (e) {
      // Handle any other unexpected errors
      return ApiResponse(success: false, message: 'Unexpected error: $e');
    }
  }

  /// 🔹 Dio Error Handler
  static ApiResponse _handleDioError(DioException e) {
    String message = 'Unexpected error occurred.';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timed out. Please try again later.';
        break;

      case DioExceptionType.badResponse:
        // Handle non-2xx HTTP responses
        final responseData = e.response?.data is Map ? e.response?.data : {};
        final statusCode = e.response?.statusCode;

        // Try to extract an error message from the response body
        message = responseData?['reason'] ??
            responseData?['message'] ??
            'Request failed ($statusCode).';
        break;

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          // SocketException usually indicates no internet connection
          message = 'No internet connection. Please check your network.';
        } else {
          message = 'Network error or unhandled connection issue.';
        }
        break;

      case DioExceptionType.cancel:
        message = 'Request cancelled.';
        break;

      case DioExceptionType.badCertificate:
        message = 'Certificate verification failed.';
        break;
    }

    // You might log the error here for debugging: print('Dio Error: $e');

    return ApiResponse(success: false, message: message);
  }
}
