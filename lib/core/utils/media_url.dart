import 'package:almasry_2/core/constants/app_api.dart';

String mediaUrlFrom(String? path) {
  final String trimmed = path?.trim() ?? '';

  if (trimmed.isEmpty) return '';

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final String suffix = trimmed.startsWith('/') ? trimmed : '/$trimmed';

  return '${ApiConstants.mediaBaseUrl}/media/catalog/product$suffix';
}
