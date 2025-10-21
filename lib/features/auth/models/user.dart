class User {
  final String id;
  final String email;
  final String? role;
  final String fullName;

  User({
    required this.id,
    required this.email,
    this.role,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'], // might be null
      fullName: json['fullName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role,
    'fullName': fullName,
  };
}
