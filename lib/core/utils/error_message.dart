import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

/// Turns anything a `catch (error)` can hand you into copy that is safe to
/// show. The one place that decides the fallback wording — every ViewModel
/// used to carry its own private copy of this.
///
/// `GraphQLService` and `ApiService` only dig the raw string out of their
/// respective exception types and may come back empty; this fills that gap.
String errorMessageFrom(Object error) {
  if (error is GraphQLServiceException) {
    return _orFallback(error.message);
  }

  if (error is DioException) {
    return _orFallback(_fromDio(error));
  }

  return LocaleKeys.somethingWentWrong.tr();
}

/// Magento replies with `{"message": "..."}` on a failed REST call.
String _fromDio(DioException error) {
  final data = error.response?.data;

  if (data is Map) {
    final message = data['message'];

    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
  }

  return error.message ?? '';
}

/// Past this, a "message" is a payload dump rather than something a shopper
/// can act on. Magento's own validation copy is well inside it.
const int _maxMessageLength = 240;

/// `GraphQLService` and `ApiService` hand back whatever string they can find,
/// which for a non-JSON reply (an HTML error page, a gateway timeout body) is
/// the raw response. That is not copy: it says nothing useful and it is long
/// enough to overflow the view showing it. Anything implausible becomes the
/// generic line instead.
String _orFallback(String message) {
  final String trimmed = message.trim();

  final bool isUsable =
      trimmed.isNotEmpty &&
      trimmed.length <= _maxMessageLength &&
      !trimmed.startsWith('<');

  if (isUsable) return trimmed;

  // Swallowing it on screen must not mean losing it: this is exactly the case
  // where the real cause is worth reading.
  if (trimmed.isNotEmpty) {
    debugPrint('Discarded unusable error message: $trimmed');
  }

  return LocaleKeys.somethingWentWrong.tr();
}
