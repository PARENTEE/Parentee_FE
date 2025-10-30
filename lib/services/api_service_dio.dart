import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/models/api_response.dart';
import 'package:parentee_fe/services/shared_preferences_service.dart'; // Assuming this path is correct

class ApiServiceDio {
  // 1. Singleton Instance and Factory
  static final ApiServiceDio _instance = ApiServiceDio._internal();
  factory ApiServiceDio() => _instance;

  // 2. Private Dio instance
  late final Dio _dio;

  // 3. Base URL
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1/';

  // 4. Private constructor (for the singleton)
  ApiServiceDio._internal();

  // 5. Public Initialization Method
  /// Cấu hình và khởi tạo Dio. BẮT BUỘC phải gọi hàm này MỘT LẦN.
  static void initialize() {
    // We use a local method to ensure we only configure the instance once.
    if (_instance._dioInitialized) return;

    _instance._dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Thêm LogInterceptor
    _instance._dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => print("DIO LOG: $object"),
      ),
    );

    _instance._dioInitialized = true;
  }

  Future<ApiResponse> sendRequestWithLoading(BuildContext context,
      String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? data,
  }) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    var response = await _instance.sendRequest(
      endpoint,
      method: method,
      data: data,
    );

    // Remove loading
    Navigator.pop(context);

    return response;
  }

  // Add a simple flag to track initialization
  bool _dioInitialized = false;

  // --------------------------
  // 🔹 API Endpoints (Now instance methods, but callable via static access)
  // --------------------------

  static Future<ApiResponse> login(String email, String password) async {
    return await _instance.sendRequest(
      'auth/login',
      method: 'POST',
      data: {'email': email, 'password': password},
    );
  }

  static Future<ApiResponse> getUserProfile(String token) async {
    return await _instance.sendRequest(
      'user/current',
      method: 'GET',
    );
  }

  // ... (Other static methods like register, signInWithGoogle, getUserProfile
  //      must also be refactored to call _instance._sendRequest) ...

  // --------------------------
  // 🔹 Generic Request Handler (Instance method)
  // --------------------------

  Future<ApiResponse> sendRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? data,
  }) async {
    // Ensure initialization is done, this throws the error if not called in main()
    // but avoids the 'already initialized' error.
    if (!_dioInitialized) {
      throw StateError(
        "ApiServiceDio must be initialized by calling ApiServiceDio.initialize() in main().",
      );
    }

    print('Call API with full endpoint: $baseUrl/$endpoint');

    String? token = await SharedPreferencesService.getToken();

    final options = Options(
      method: method,
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    try {
      final Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(endpoint, data: data, options: options)
              .timeout(const Duration(seconds: 10));
          break;
        case 'PUT':
          response = await _dio.put(endpoint, data: data, options: options)
              .timeout(const Duration(seconds: 10));
          break;
        case 'DELETE':
          response = await _dio.delete(endpoint, data: data, options: options)
              .timeout(const Duration(seconds: 10));
          break;
        case 'GET':
          response = await _dio.get(endpoint, data: data, options: options)
              .timeout(const Duration(seconds: 10));
          break;
        default:
          response = await _dio.get(
            endpoint,
            options: options,
            queryParameters: data,
          );
      }

      final Map<String, dynamic> jsonBody =
          response.data is Map ? response.data : {};
      return ApiResponse(success: true, message: jsonBody['message'] ,data: jsonBody['data']);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Unexpected application error: $e',
      );
    }
  }

  // --------------------------
  // 🔹 Dio Error Handler (No change needed here)
  // --------------------------

  static ApiResponse _handleDioError(DioException e) {
    // ... (Your error handling logic remains the same) ...
    String message = 'Unexpected error occurred.';

    switch (e.type) {
      // ... (implementation of error handling) ...
      case DioExceptionType.badResponse:
        final responseData = e.response?.data;
        final statusCode = e.response?.statusCode;
        if (responseData is Map<String, dynamic>) {
          message = responseData['reason'] ??
              responseData['message'] ??
              responseData['error'] ??
              'Request failed with status $statusCode.';
        } else {
          message = 'Request failed ($statusCode).';
        }
        break;
      // ... (other cases) ...
      case DioExceptionType.connectionTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.sendTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.receiveTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.cancel:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.connectionError:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.unknown:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    print('DIO ERROR: ${e.toString()}');
    return ApiResponse(success: false, message: message);
  }
}
