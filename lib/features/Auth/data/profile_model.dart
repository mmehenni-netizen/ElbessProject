class ProfileModel {
	final bool success;
	final String message;
	final ProfileUser? user;

	ProfileModel({
		required this.success,
		required this.message,
		this.user,
	});

	factory ProfileModel.fromJson(Map<String, dynamic> json) {
		final userJson = json['user'];
		return ProfileModel(
			success: json['success'] == true,
			message: (json['message'] as String?) ?? '',
			user: userJson is Map<String, dynamic>
					? ProfileUser.fromJson(userJson)
					: null,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'success': success,
			'message': message,
			if (user != null) 'user': user!.toJson(),
		};
	}
}

class ProfileUser {
	final String firstName;
	final String lastName;
	final String phone;
	final DateTime? dateOfBirth;
	final String address;
	final String gender;

	ProfileUser({
		required this.firstName,
		required this.lastName,
		required this.phone,
		required this.dateOfBirth,
		required this.address,
		required this.gender,
	});

	factory ProfileUser.fromJson(Map<String, dynamic> json) {
		final rawDateOfBirth = json['dateOfBirth'];
		final parsedDateOfBirth = rawDateOfBirth is String
				? DateTime.tryParse(rawDateOfBirth)
				: rawDateOfBirth is int
						? DateTime.fromMillisecondsSinceEpoch(rawDateOfBirth)
						: rawDateOfBirth is DateTime
								? rawDateOfBirth
								: null;

		return ProfileUser(
			firstName: (json['firstName'] as String?) ?? '',
			lastName: (json['lastName'] as String?) ?? '',
			phone: (json['phone'] as String?) ?? '',
			dateOfBirth: parsedDateOfBirth,
			address: (json['address'] as String?) ?? '',
			gender: (json['gender'] as String?) ?? '',
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'firstName': firstName,
			'lastName': lastName,
			'phone': phone,
			'dateOfBirth': dateOfBirth?.toIso8601String(),
			'address': address,
			'gender': gender,
		};
	}
}
