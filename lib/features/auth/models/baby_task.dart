// lib/dto/get_task_response.dto.dart
import 'package:flutter/material.dart'; // Or wherever your TaskStatus is

class BabyTask {
  final String id;
  final String familyId;
  final String? childId;
  final String title;
  final String? description;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String status;
  final bool allDay;
  final String? createdBy;
  final DateTime? deletedAt;

  BabyTask({
    required this.id,
    required this.familyId,
    this.childId,
    required this.title,
    this.description,
    this.startsAt,
    this.endsAt,
    required this.status,
    required this.allDay,
    this.createdBy,
    this.deletedAt,
  });

  /// A factory constructor for creating a new GetTaskResponseDto instance from a map.
  /// This is the standard way to parse JSON in Dart.
  factory BabyTask.fromJson(Map<String, dynamic> json) {
    return BabyTask(
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

      status: json['status'] as String,

      allDay: json['allDay'] as bool,
      createdBy: json['createdBy'] as String?,

      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
    );
  }
}
