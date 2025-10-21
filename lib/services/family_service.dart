import 'package:parentee_fe/features/auth/models/api_response.dart';
import 'package:parentee_fe/services/api_service_dio.dart';

class FamilyService {
  static final ApiServiceDio _apiServiceDioInstance = ApiServiceDio();

  // ------------------
  // -- GET
  // ------------------

  static Future<ApiResponse> getFamilyThroughToken() async {
    return await _apiServiceDioInstance.sendRequest(
      'families/details/token',
      method: 'GET',
    );
  }

  static Future<ApiResponse> getUserWithNoFamily() async {
    return await _apiServiceDioInstance.sendRequest(
      'user/no-family',
      method: 'GET',
    );
  }

  static Future<ApiResponse> getInvitation() async {
    return await _apiServiceDioInstance.sendRequest(
      'families/invitations',
      method: 'GET',
    );
  }

  // ------------------
  // -- POST
  // ------------------

  static Future<ApiResponse> createFamily(String name) async {
    return await _apiServiceDioInstance.sendRequest(
      'families',
      method: 'POST',
      data: {'name': name},
    );
  }

  static Future<ApiResponse> sendInvitation(String familyId, String userId, int role) async {
    return await _apiServiceDioInstance.sendRequest(
      'families/${familyId}/invite',
      method: 'POST',
      data: { 'userId': userId, 'role': role },
    );
  }

  static Future<ApiResponse> updateInvitation(String id, bool isAccepted) async {
    return await _apiServiceDioInstance.sendRequest(
      'families/user-family-role/${id}/${isAccepted}',
      method: 'POST'
    );
  }

}