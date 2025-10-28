class Child {
  final String id;
  final String fullName;
  final DateTime birthDate;
  final String sex;
  final double height;
  final double weight;
  final String? photoImageId;
  final String notes;

  Child({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.sex,
    required this.height,
    required this.weight,
    required this.photoImageId,
    required this.notes,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      birthDate: DateTime.parse(json['birthDate']),
      sex: json['sex'] ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      photoImageId: json['photoImageId'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'birthDate': birthDate.toIso8601String(),
      'sex': sex,
      'height': height,
      'weight': weight,
      'photoImageId': photoImageId,
      'notes': notes,
    };
  }
}
