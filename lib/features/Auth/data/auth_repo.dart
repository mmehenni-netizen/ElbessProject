
import 'package:dio/dio.dart';
import 'package:elbess/core/network/api_error.dart';
import 'package:elbess/core/network/api_exception.dart';
import 'package:elbess/core/network/api_service.dart';
import 'package:elbess/core/utils/pref_helpers.dart';
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
        throw e;
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
        throw e;
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
        throw e;
      }
      throw ApiError(message: e.toString());
    }
  }

}