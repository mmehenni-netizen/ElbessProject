import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/features/profile/data/userprofile.dart';
import 'package:flutter/material.dart';

class ProfileRepo {
  ApiService _apiService=ApiService();
   // Add methods to fetch and update user profile data
Future<UserProfile?> getProfile() async {
  try {
    final response = await _apiService.get('/actions/get-profile');

    if (response is ApiError) {
      debugPrint('getProfile error: ${response.message}');
      return null;
    }

    if (response is! Map<String, dynamic>) {
      debugPrint('getProfile: unexpected response type');
      return null;
    }

    if (response['success'] != true) {
      debugPrint('getProfile failed: ${response['message']}');
      return null;
    }

    final userJson = response['user'];
    if (userJson is! Map<String, dynamic>) return null;

    return UserProfile.fromJson(userJson);
  } catch (e) {
    debugPrint('Error fetching profile: $e');
    return null;
  }
}

}