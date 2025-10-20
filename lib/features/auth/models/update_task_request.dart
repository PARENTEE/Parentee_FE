import 'task_status.dart'; // Import the enum

class UpdateTaskRequest {
  final String? title;
  final String? description;
  final TaskStatus? status; // ✨ Use the nullable enum

  UpdateTaskRequest({
    this.title,
    this.description,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (status != null) {
      data['status'] = status!.index; // ✨ Send the integer index of the enum
    }

    return data;
  }
}
