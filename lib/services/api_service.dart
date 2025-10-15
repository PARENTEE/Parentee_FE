import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:parentee_fe/features/auth/models/api_response.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api/v1';
  // static const String baseUrl = 'http://10.0.2.2:5000/api/v1';

  // --------------------------
  // 🔹 API Endpoints
  // --------------------------

  static Future<ApiResponse> login(String email, String password) async {
    return await _sendRequest(
      'auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
    );
  }

  static Future<ApiResponse> register(
      String email, String fullName, String phone, String password) async {
    return await _sendRequest(
      'user',
      method: 'POST',
      body: {
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
      body: {'email': email, 'fullName': fullName},
    );
  }

  static Future<ApiResponse> getUserProfile(String token) async {
    return await _sendRequest(
      'user/current',
      token: token,
      method: 'GET',
    );
  }

  /// 🔹 Generic request handler
  static Future<ApiResponse> _sendRequest(
    String endpoint, {
    String method = 'GET',
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    print('Call API with endpoint: $baseUrl/$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try {
      http.Response response;

      // Handle method
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http
              .post(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 10));
          break;

        case 'PUT':
          response = await http
              .put(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 10));
          break;

        case 'DELETE':
          response = await http
              .delete(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 10));
          break;

        default:
          response = await http
              .get(url, headers: headers)
              .timeout(const Duration(seconds: 10));
      }

      // 🔹 Parse response
      final jsonBody = _tryDecodeJson(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(success: true, data: jsonBody['data']);
      } else {
        final message = jsonBody['reason'] ??
            jsonBody['message'] ??
            'Request failed (${response.statusCode})';
        return ApiResponse(success: false, message: message);
      }
    } on TimeoutException {
      return ApiResponse(
          success: false,
          message: 'Request timed out. Please try again later.');
    } on SocketException {
      return ApiResponse(
          success: false,
          message: 'No internet connection. Please check your network.');
    } on HttpException {
      return ApiResponse(
          success: false, message: 'Server error. Please try again later.');
    } catch (e) {
      return ApiResponse(success: false, message: 'Unexpected error: $e');
    }
  }

  /// 🔹 Safe JSON decode helper
  static dynamic _tryDecodeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return {};
    }
  }
}
