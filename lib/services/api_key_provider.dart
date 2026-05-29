
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeyProvider {
  static String? _normalize(String? value) {
    if (value == null) {
      return null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
        (trimmed.startsWith("'") && trimmed.endsWith("'"))) {
      return trimmed.substring(1, trimmed.length - 1).trim();
    }

    return trimmed;
  }

  static String? fromDotEnv() {
    final geminiKey = _normalize(dotenv.env['GEMINI_API_KEY']);
    if (geminiKey != null) {
      return geminiKey;
    }

    final legacyKey = _normalize(dotenv.env['GENAI_API_KEY']);
    if (legacyKey != null) {
      return legacyKey;
    }

    return null;
  }

  static String? fromDartDefine() {
    const geminiKey = String.fromEnvironment('GEMINI_API_KEY');
    final normalizedGeminiKey = _normalize(geminiKey);
    if (normalizedGeminiKey != null) {
      return normalizedGeminiKey;
    }

    const legacyKey = String.fromEnvironment('GENAI_API_KEY');
    final normalizedLegacyKey = _normalize(legacyKey);
    if (normalizedLegacyKey != null) {
      return normalizedLegacyKey;
    }

    return null;
  }

  static String? fromAnySource() => fromDotEnv() ?? fromDartDefine();

  /// Returns the key or throws if missing.
  static String requireApiKey() {
    final k = fromAnySource();
    if (k == null || k.isEmpty) {
      throw StateError(
        'GEMINI_API_KEY not provided. Add it to .env or start the app with --dart-define=GEMINI_API_KEY=...',
      );
    }

    return k;
  }
}
