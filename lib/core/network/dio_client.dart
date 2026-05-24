import 'package:dio/dio.dart' show BaseOptions, Dio, InterceptorsWrapper;
import 'package:elbess/core/network/network_config.dart';
import 'package:elbess/core/utils/pref_helpers.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _resolveBaseUrl(),
      headers: {"Content-Type": "application/json"},
    ),
  );
  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelpers.getToken();
          // Debug: log resolved base URL and token presence
          try {
            // ignore: avoid_print
            print('DioClient: baseUrl=${options.baseUrl}');
            // ignore: avoid_print
            print('DioClient: token present=${token != null && token.isNotEmpty}');
          } catch (_) {}

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }
  Dio get dio => _dio;

  static String _resolveBaseUrl() {
    final overrideBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    ).trim();

    if (overrideBaseUrl.isNotEmpty) {
      return _normalizeBaseUrl(overrideBaseUrl);
    }

    return apiBaseUrl;
  }

  static String _normalizeBaseUrl(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return baseUrl;
    }

    // Android emulators cannot reach the host machine through localhost.
    // Map loopback hosts to the standard emulator host.
    final isAndroidEmulator = uri.scheme == 'http' || uri.scheme == 'https';
    final host = uri.host;
    if (isAndroidEmulator && (host == 'localhost' || host == '127.0.0.1')) {
      return uri.replace(host: '10.0.2.2').toString();
    }

    return baseUrl;
  }
}
