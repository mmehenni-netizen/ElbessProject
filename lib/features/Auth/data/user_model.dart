class UserModel {
  final bool success;
  final String message;

  final String? id;
  final String email;
  final String username;
  final String? verificationToken;
  final int? verificationTokenExpiresAt;

  UserModel({
    required this.success,
    required this.message,
     this.id,
    required this.email,
    required this.username,
     this.verificationToken,
     this.verificationTokenExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : <String, dynamic>{};

    final expiresAt = user['verificationTokenExpiresAt'];
    final parsedExpiresAt = expiresAt is int
        ? expiresAt
        : expiresAt is String
            ? int.tryParse(expiresAt)
            : null;

    return UserModel(
      success: json['success'] == true,
      message: (json['message'] as String?) ?? '',
      id: user['_id'] as String?,
      email: (user['email'] as String?) ?? '',
      username: (user['username'] as String?) ?? '',
      verificationToken: user['verificationToken'] as String?,
      verificationTokenExpiresAt: parsedExpiresAt,
    );
  }
}