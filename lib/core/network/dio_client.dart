import 'package:dio/dio.dart';
import 'package:elbess/core/network/network_config.dart';
import 'package:elbess/core/utils/pref_helpers.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _resolveBaseUrl(),
      headers: {"Content-Type": "application/json"},
      // Increased timeouts to accommodate cold starts on Render
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ),
  );
  DioClient() {
    _dio.interceptors.add(InterceptorsWrapper(
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
      onError: (err, handler) async {
        // Retry on timeout or server errors (simple exponential backoff)
        final requestOptions = err.requestOptions;
        final shouldRetry = err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            (err.response != null && (err.response!.statusCode ?? 0) >= 500);

        if (shouldRetry) {
          final retries = (requestOptions.extra['retries'] as int?) ?? 0;
          if (retries < 2) {
            final waitSeconds = 1 << retries; // 1, 2
            try {
              await Future.delayed(Duration(seconds: waitSeconds));
              requestOptions.extra['retries'] = retries + 1;
              final response = await _dio.fetch(requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(e is DioException ? e : DioException(requestOptions: requestOptions, error: e));
            }
          }
        }

        return handler.next(err);
      },
    ));
  }
  Dio get dio => _dio;

  static String _resolveBaseUrl() {
    final overrideBaseUrl = const String.fromEnvironment(
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
      return _ensureSingleApiPath(uri.replace(host: '10.0.2.2').toString());
    }

    return _ensureSingleApiPath(baseUrl);
  }

  static String _ensureSingleApiPath(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.endsWith('/api/api')) {
      return trimmed.substring(0, trimmed.length - 4);
    }
    return trimmed;
  }
}
