import 'family_user.dart';

class Family {
  final String id;
  final String name;
  final String? coverImageId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FamilyUser> familyUsers;

  Family({
    required this.id,
    required this.name,
    this.coverImageId,
    required this.createdAt,
    required this.updatedAt,
    required this.familyUsers,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      coverImageId: json['coverImageId'] as String?,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      familyUsers: (json['familyUsers'] as List<dynamic>? ?? [])
          .map((u) => FamilyUser.fromJson(u as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'coverImageId': coverImageId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'familyUsers': familyUsers.map((u) => u.toJson()).toList(),
  };
}
