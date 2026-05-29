class UserProfile {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isSeller;
  final bool isVerified;
  final DateTime? lastLogin;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    required this.isSeller,
    required this.isVerified,
    required this.lastLogin,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id:          json['id']?.toString()        ?? '',
      username:    json['username']?.toString()  ?? '',
      email:       json['email']?.toString()     ?? '',
      firstName:   json['firstName']?.toString() ?? '',
      lastName:    json['lastName']?.toString()  ?? '',
      phone:       json['phone']?.toString()     ?? '',
      address:     json['address']?.toString()   ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      gender:      json['gender']?.toString(),
      isSeller:    json['isSeller']  as bool? ?? false,
      isVerified:  json['isVerified'] as bool? ?? false,
      lastLogin:   json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'].toString())
          : null,
      createdAt:   json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':          id,
    'username':    username,
    'email':       email,
    'firstName':   firstName,
    'lastName':    lastName,
    'phone':       phone,
    'address':     address,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'gender':      gender,
    'isSeller':    isSeller,
    'isVerified':  isVerified,
    'lastLogin':   lastLogin?.toIso8601String(),
    'createdAt':   createdAt?.toIso8601String(),
  };

  bool get hasCompletedProfile =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      phone.isNotEmpty &&
      address.isNotEmpty &&
      dateOfBirth != null &&
      gender != null;
}