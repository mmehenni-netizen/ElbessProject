
class ApiKeyProvider {

  static String? fromDartDefine() => const String.fromEnvironment('GENAI_API_KEY');

  /// Returns the key or throws if missing.
  static String requireFromDartDefine() {
    final k = fromDartDefine();
    if (k == null || k.isEmpty) {
      throw StateError('GENAI_API_KEY not provided. Start the app with `--dart-define=GENAI_API_KEY=...`');
    }
    return k;
  }
}
