// lib/models/task_status.dart

enum TaskStatus {
  pending,
  completed,
  cancelled,
}

/// Helper extension to safely parse a string into a TaskStatus enum.
extension TaskStatusParser on String {
  TaskStatus toTaskStatus() {
    switch (toLowerCase()) {
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      case 'pending':
      default: // If the API sends an unknown status, default to pending
        return TaskStatus.pending;
    }
  }
}
