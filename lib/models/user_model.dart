class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.isEmailVerified,
  });

  final String id;
  final String email;
  final String displayName;
  final bool isEmailVerified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'is_email_verified': isEmailVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
