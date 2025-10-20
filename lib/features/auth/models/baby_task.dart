// lib/dto/get_task_response.dto.dart

import '../models/task_status.dart'; // Make sure this path is correct

class GetTaskResponseDto {
  final String id;
  final String familyId;
  final String? childId;
  final String title;
  final String? description;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final TaskStatus status; // ✨ Using the enum
  final bool allDay;
  final String? createdBy;
  final DateTime? deletedAt;

  GetTaskResponseDto({
    required this.id,
    required this.familyId,
    this.childId,
    required this.title,
    this.description,
    this.startsAt,
    this.endsAt,
    required this.status, // ✨ Using the enum
    required this.allDay,
    this.createdBy,
    this.deletedAt,
  });

  /// A factory constructor for creating a new GetTaskResponseDto instance from a map.
  factory GetTaskResponseDto.fromJson(Map<String, dynamic> json) {
    return GetTaskResponseDto(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      childId: json['childId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,

      // Safely parse DateTime strings, returning null if the string is null
      startsAt: json['startsAt'] != null
          ? DateTime.parse(json['startsAt'] as String)
          : null,

      endsAt: json['endsAt'] != null
          ? DateTime.parse(json['endsAt'] as String)
          : null,

      // ✅ Use the parser to convert the string from JSON to the TaskStatus enum
      status: (json['status'] as String).toTaskStatus(),

      allDay: json['allDay'] as bool,
      createdBy: json['createdBy'] as String?,

      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
    );
  }
}
