import 'package:flutter/cupertino.dart';
import 'package:parentee_fe/features/auth/models/api_response.dart';
import 'package:parentee_fe/services/api_service_dio.dart';

class ChildService {
  static final ApiServiceDio _apiServiceDioInstance = ApiServiceDio();

  // ------------------
  // -- GET
  // ------------------

  static Future<ApiResponse> getChildrenInCurrentFamily(BuildContext context) async {
    return await _apiServiceDioInstance.sendRequestWithLoading(
      context,
      'child/current-family',
      method: 'GET',
    );
  }

  static Future<ApiResponse> getChildById(BuildContext context, String childId) async {
    return await _apiServiceDioInstance.sendRequestWithLoading(
      context,
      'child/${childId}',
      method: 'GET',
    );
  }

  static Future<ApiResponse> createChild(
      BuildContext context,
      dynamic data,
      ) async {
    return await _apiServiceDioInstance.sendRequestWithLoading(
      context,
      'child',
      method: 'POST',
      data: data,
    );
  }

  static Future<ApiResponse> updateChild(
      BuildContext context,
      String childId,
      dynamic data,
      ) async {
    return await _apiServiceDioInstance.sendRequestWithLoading(
      context,
      'child/${childId}',
      method: 'PUT',
      data: data,
    );
  }

  static Future<ApiResponse> createFeeding(dynamic data) async {
    return await _apiServiceDioInstance.sendRequest(
      'feeding',
      method: 'POST',
      data: data,
    );
  }

  static Future<ApiResponse> createSleepRecord(
    BuildContext context,
    dynamic data,
  ) async {
    return await _apiServiceDioInstance.sendRequestWithLoading(
      context,
      'sleep',
      method: 'POST',
      data: data,
    );
  }

  static Future<ApiResponse> createDiaperChangeRecord(
      BuildContext context,
      dynamic data,
      ) async {
    return await _apiServiceDioInstance.sendRequestWithLoading(
      context,
      'diaperchange',
      method: 'POST',
      data: data,
    );
  }
}
