class Invitation {
  final String userFamilyRoleId;
  final String inviterName;
  final String role;
  final DateTime createdAt;

  Invitation({
    required this.userFamilyRoleId,
    required this.inviterName,
    required this.role,
    required this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      userFamilyRoleId: json['userFamilyRoleId'],
      inviterName: json['inviterName'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}