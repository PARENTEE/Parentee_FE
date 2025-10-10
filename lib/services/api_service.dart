import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
  // For Android Emulator; use your LAN IP if testing on real device

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Login failed',
      };
    }
  }

  static Future<Map<String, dynamic>> register(
      String email, String fullName, String phone, String password) async {
    final url = Uri.parse('$baseUrl/user');

    try {
      // Set timeout (10 seconds)
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'fullName': fullName,
          'phone': phone,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10)); // ⏱ giới hạn thời gian

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Nếu API trả lỗi (400, 500, ...)
        String message = 'Registration failed';
        try {
          final jsonBody = jsonDecode(response.body);
          message = jsonBody['reason'] ?? jsonBody['message'] ?? message;
        } catch (_) {}
        return {
          'success': false,
          'message': message,
        };
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
}
