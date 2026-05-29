import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

const String _defaultHost = 'http://localhost:5000';
const String _envApiHost = String.fromEnvironment(
  'API_HOST',
  defaultValue: '',
);

String get apiHost {
  final host = _normalizeApiHost(
    _envApiHost.isNotEmpty ? _envApiHost : _defaultHost,
  );

  // On Android emulators, `localhost` refers to the emulator. Map it to
  // the host machine using the standard emulator host `10.0.2.2` so the
  // app can reach a locally-running backend without extra dart-define.
  final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  if (isAndroid) {
    if (host.contains('localhost')) {
      return host.replaceAll('localhost', '10.0.2.2');
    }
    if (host.contains('127.0.0.1')) {
      return host.replaceAll('127.0.0.1', '10.0.2.2');
    }
  }

  return host;
}

String get apiBaseUrl => '$apiHost/api';

String _normalizeApiHost(String host) {
  final trimmed = host.trim();
  if (trimmed.endsWith('/api')) {
    return trimmed.substring(0, trimmed.length - 4);
  }
  if (trimmed.endsWith('/')) {
    return trimmed.substring(0, trimmed.length - 1);
  }
  return trimmed;
}

String resolveNetworkUrl(String rawPath) {
  final trimmed = rawPath.trim();

  if (trimmed.isEmpty) {
    return '';
  }

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  if (trimmed.startsWith('/')) {
    return '$apiHost$trimmed';
  }

  if (trimmed.startsWith('uploads/')) {
    return '$apiHost/$trimmed';
  }

  return trimmed;
}
