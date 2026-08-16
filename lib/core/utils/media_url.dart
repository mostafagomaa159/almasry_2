import 'package:almasry_2/core/constants/app_api.dart';

/// Magento is inconsistent about media URLs: `image.url` comes back absolute,
/// while `thumbnail.url` and `small_image.url` are catalogue-relative
/// (`/i/s/isg009085.jpg`). This makes both usable by `AppNetworkImage`.
String mediaUrlFrom(String? path) {
  final String trimmed = path?.trim() ?? '';

  if (trimmed.isEmpty) return '';

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final String suffix = trimmed.startsWith('/') ? trimmed : '/$trimmed';

  return '${ApiConstants.mediaBaseUrl}/media/catalog/product$suffix';
}
