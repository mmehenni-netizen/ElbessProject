import 'package:elbess/services/generative_ai_service.dart';

/// Small non-UI runner that calls the GenerativeAIService.
class GenerativeAIRunner {
 
  static Future<String> runExampleWithKey(String apiKey, String prompt) async {
    final svc = GenerativeAIService(apiKey);
    final out = await svc.generateText(prompt);
    return out;
  }
}
