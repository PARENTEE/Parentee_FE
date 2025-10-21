class FamilyUser {
  final String id;
  final String email;
  final String? role;
  final String fullName;
  final int gender;
  final String familyRole;
  final int invitationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilyUser({
    required this.id,
    required this.email,
    this.role,
    required this.fullName,
    required this.gender,
    required this.familyRole,
    required this.invitationStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FamilyUser.fromJson(Map<String, dynamic> json) {
    return FamilyUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] as String?, // ✅ safe cast
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? 0,
      familyRole: json['familyRole'] ?? '',
      invitationStatus: json['invitationStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role,
    'fullName': fullName,
    'gender': gender,
    'familyRole': familyRole,
    'invitationStatus': invitationStatus,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
