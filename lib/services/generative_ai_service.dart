import 'package:dio/dio.dart';

class GenerativeAIService {
  final String apiKey;
  final String model;
  final Dio _dio;

  GenerativeAIService(
    this.apiKey, {
    String? modelName,
    Dio? dio,
  }) : model = modelName ?? const String.fromEnvironment(
          'GENAI_MODEL',
          defaultValue: 'gemini-2.5-flash',
        ),
      _dio = dio ?? Dio();

  /// Generates text for [prompt].
  ///
  /// Returns the generated string on success or throws on failure.
  Future<String> generateText(
    String prompt, {
    double temperature = 0.2,
    int maxOutputTokens = 512,
  }) async {
    try {
      final uri = Uri.https(
        'generativelanguage.googleapis.com',
        '/v1beta/models/$model:generateContent',
        <String, String>{'key': apiKey},
      );

      final response = await _dio.postUri(
        uri,
        data: <String, dynamic>{
          'contents': <Map<String, dynamic>>[
            <String, dynamic>{
              'role': 'user',
              'parts': <Map<String, dynamic>>[
                <String, dynamic>{'text': prompt},
              ],
            },
          ],
          'generationConfig': <String, dynamic>{
            'temperature': temperature,
            'maxOutputTokens': maxOutputTokens,
          },
        },
        options: Options(
          headers: <String, dynamic>{'Content-Type': 'application/json'},
          responseType: ResponseType.json,
        ),
      );

      final output = _extractText(response.data);
      if (output != null && output.isNotEmpty) {
        return output;
      }

      throw Exception('Empty response from Gemini API');
    } on DioException catch (error) {
      final message = _extractDioMessage(error);
      throw Exception(message);
    }
  }

  String? _extractText(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      return null;
    }

    final firstCandidate = candidates.first;
    if (firstCandidate is! Map<String, dynamic>) {
      return null;
    }

    final content = firstCandidate['content'];
    if (content is! Map<String, dynamic>) {
      return null;
    }

    final parts = content['parts'];
    if (parts is! List) {
      return null;
    }

    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map<String, dynamic>) {
        final text = part['text'];
        if (text is String && text.isNotEmpty) {
          buffer.write(text);
        }
      }
    }

    final output = buffer.toString().trim();
    return output.isEmpty ? null : output;
  }

  String _extractDioMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final errorData = responseData['error'];
      if (errorData is Map<String, dynamic>) {
        final message = errorData['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
      }
    }

    return error.message ?? 'Failed to call Gemini REST API';
  }
}
