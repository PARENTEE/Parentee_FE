import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1';


  // --------------------------
  // 🔹 API Endpoints
  // --------------------------

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return _sendRequest(
      'auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
    );
  }

  static Future<Map<String, dynamic>> register(
      String email, String fullName, String phone, String password) async {
    return _sendRequest(
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

  static Future<Map<String, dynamic>> signInWithGoogle(
      String email, String fullName) async {
    return _sendRequest(
      'auth/signin-google',
      method: 'POST',
      body: {'email': email, 'fullName': fullName},
    );
  }

  /// 🔹 Generic request handler
  static Future<Map<String, dynamic>> _sendRequest(
      String endpoint, {
        String method = 'GET',
        Map<String, dynamic>? body,
      })
  async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      http.Response response;

      // Handle method
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http
              .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          )
              .timeout(const Duration(seconds: 10));
          break;

        case 'PUT':
          response = await http
              .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          )
              .timeout(const Duration(seconds: 10));
          break;

        case 'DELETE':
          response = await http
              .delete(
            url,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          )
              .timeout(const Duration(seconds: 10));
          break;

        default:
          response = await http
              .get(url, headers: {'Content-Type': 'application/json'})
              .timeout(const Duration(seconds: 10));
      }

      // 🔹 Parse response
      final jsonBody = _tryDecodeJson(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': jsonBody};
      } else {
        final message = jsonBody['reason'] ??
            jsonBody['message'] ??
            'Request failed (${response.statusCode})';
        return {'success': false, 'message': message};
      }
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Request timed out. Please try again later.',
      };
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please check your network.',
      };
    } on HttpException {
      return {
        'success': false,
        'message': 'Server error. Please try again later.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: $e',
      };
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
