import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

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

String _orFallback(String message) {
  return message.trim().isNotEmpty
      ? message
      : LocaleKeys.somethingWentWrong.tr();
}
