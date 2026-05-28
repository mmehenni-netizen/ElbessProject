import 'dart:convert';

import 'package:dio/dio.dart';


class GenerativeAIService {
  final String apiKey;
  final Dio _dio;
  final String model;

  GenerativeAIService(this.apiKey, {Dio? dio, this.model = 'models/text-bison-001'}) : _dio = dio ?? Dio() {
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  /// Generates text for [prompt].
  ///
  /// Returns the generated string on success or throws on failure.
  Future<String> generateText(String prompt, {double temperature = 0.2, int maxOutputTokens = 512}) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta2/$model:generateText?key=$apiKey';

    final body = {
      'prompt': {'text': prompt},
      'temperature': temperature,
      'maxOutputTokens': maxOutputTokens,
    };

    final resp = await _dio.post(url, data: jsonEncode(body));

    if (resp.statusCode == 200) {
      final data = resp.data;
      if (data is Map) {
        // Try common response shapes from Generative Language API
        if (data['candidates'] != null && data['candidates'] is List && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content'] ?? data['candidates'][0].toString();
        }
        if (data['output'] != null) return data['output'].toString();
        if (data['text'] != null) return data['text'].toString();
      }
      return resp.data.toString();
    }

    throw Exception('Failed to generate text: ${resp.statusCode} ${resp.statusMessage} ${resp.data}');
  }
}


