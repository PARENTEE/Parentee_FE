import 'package:dio/dio.dart';
import 'package:parentee_fe/features/auth/models/baby_task.dart';
import 'package:parentee_fe/services/api_client.dart';
import 'package:intl/intl.dart';

class TaskService {
  final ApiClient _apiClient;

  TaskService({ApiClient? api_client}) : _apiClient = api_client ?? ApiClient();

  Future<List<GetTaskResponseDto>> getTasksByDate(
      Guid familyId, DateTime date) async {
    try {
      // Format the date to 'yyyy-MM-dd' as the API likely expects
      // final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      // Make the GET request
      final response =
          await _apiClient.dio.get('/tasks/$familyId/$formattedDate');

      if (response.statusCode == 200) {
        // If the server returns an OK response, then parse the JSON.
        final List<dynamic> data = response.data;
        return data.map((json) => GetTaskResponseDto.fromJson(json)).toList();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load tasks');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (e.g., network issues, timeouts)
      print('Dio error: ${e.message}');
      throw Exception('Failed to connect to the server');
    } catch (e) {
      // Handle other potential errors
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  // Example of an update function
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      // In a real app, you would send the new status in the request body
      await _apiClient.dio.patch(
        '/tasks/$taskId/status',
        data: {'status': newStatus},
      );
      print('Task $taskId updated to $newStatus');
    } catch (e) {
      throw Exception('Failed to update task');
    }
  }
}

typedef Guid = String;
