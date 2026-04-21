
import 'package:dio/dio.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/network/api_exception.dart';
import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
import 'package:elbess/features/Auth/data/profile_model.dart';
import 'package:elbess/features/Auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();

  Future<UserModel?> signup(String username, String email, String password) async {
    try {
      final response = await apiService.post('/auth/signup', {
        'username': username.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      if (response['success'] == true) {
        final token = response['token'];
        if (token is String && token.isNotEmpty) {
          await PrefHelpers.saveToken(token);
        }
        return UserModel.fromJson(response);
      }

      throw ApiError(message: response['message'] ?? 'An error occurred');
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post('/auth/login', {
        'email': email.trim().toLowerCase(),
        'password': password,
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      if (response['success'] == true) {
        final token = response['token'];
        if (token is String && token.isNotEmpty) {
          await PrefHelpers.saveToken(token);
        }
        return UserModel.fromJson(response);
      }

      throw ApiError(message: response['message'] ?? 'An error occurred');
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> verifyEmail(String code) async {
    try {
      final response = await apiService.post('/auth/verify-email', {
        'code': code.trim(),
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      if (response['success'] == true) {
        final token = response['token'];
        if (token is String && token.isNotEmpty) {
          await PrefHelpers.saveToken(token);
        }
        return UserModel.fromJson(response);
      }

      throw ApiError(message: response['message'] ?? 'An error occurred');
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }
 
  Future<ProfileModel?> setProfile(String firstName, String lastName, String phone, DateTime? dateOfBirth, String address, String gender)async{
    try{
     final response=await apiService.post('/actions/set-profile',{
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'phone': phone.trim(),
      'dateOfBirth': dateOfBirth?.toIso8601String() ?? '',
      'address': address.trim(),
      'gender': gender.trim(),
     });
      if (response is ApiError) {
          throw response;
        }
  
        if (response is! Map<String, dynamic>) {
          throw ApiError(message: 'Unexpected server response');
        }
  
        if (response['success'] == true) {
          return ProfileModel.fromJson( response);
        }
  
        throw ApiError(message: response['message'] ?? 'An error occurred');

    }catch(e){
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

  Future<ProfileModel?> getProfile() async {
    try {
      final response = await apiService.get('/fetch/get-profile');

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected server response');
      }

      if (response['success'] == true) {
        return ProfileModel.fromJson(response);
      }

      throw ApiError(message: response['message'] ?? 'An error occurred');
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: e.toString());
    }
  }

}
