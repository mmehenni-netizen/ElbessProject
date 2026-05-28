import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeAIService {
  final String apiKey;
  final String model;
  late final GenerativeModel _model;

  GenerativeAIService(this.apiKey, {this.model = 'gemini-1.5-flash'}) {
    _model = GenerativeModel(model: model, apiKey: apiKey);
  }

  /// Generates text for [prompt].
  ///
  /// Returns the generated string on success or throws on failure.
  Future<String> generateText(
    String prompt, {
    double temperature = 0.2,
    int maxOutputTokens = 512,
  }) async {
    final response = await _model.generateContent(
      <Content>[Content.text(prompt)],
      generationConfig: GenerationConfig(
        temperature: temperature,
        maxOutputTokens: maxOutputTokens,
      ),
    );

    final text = response.text?.trim();
    if (text != null && text.isNotEmpty) {
      return text;
    }

    throw Exception('Empty response from Gemini API');
  }
}
