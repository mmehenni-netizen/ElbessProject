import 'package:elbess/core/network/network_config.dart';

String resolveImageUrlNormalized(String rawPath) {
  final trimmed = rawPath.trim();

  if (trimmed.isEmpty) {
    return '';
  }

  if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
    return '';
  }

  if (trimmed.startsWith('assets/')) {
    return trimmed;
  }

  final resolvedNetworkPath = resolveNetworkUrl(trimmed);
  if (resolvedNetworkPath.startsWith('http://') ||
      resolvedNetworkPath.startsWith('https://')) {
    return resolvedNetworkPath;
  }

  if (!trimmed.contains('/') && !trimmed.contains('\\')) {
    return 'assets/Images/clothes/$trimmed';
  }

  return trimmed;
}
