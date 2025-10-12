import 'dart:convert';

import 'package:parentee_fe/features/auth/models/user.dart';
import 'package:parentee_fe/services/api_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }

  static Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson == null) return null;

    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }

  static Future<void> fetchAndSaveUser(String? token) async {
    if(token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('auth_token');
      if (token == null) return;
    }

    // Call API
    final result = await ApiService.getUserProfile(token);

    if (result['success']) {
      final user = User.fromJson(jsonDecode(result['data']));
      await saveUserToPrefs(user);
    }
    else{
      throw Exception('Không thể lấy thông tin người dùng!');
    }
  }

}