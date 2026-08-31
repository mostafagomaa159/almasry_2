import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/core/services/graphql_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

String errorMessageFrom(Object error) {
  if (error is GraphQLServiceException) {
    return _orFallback(error.message);
  }

  if (error is DioException) {
    return _orFallback(_fromDio(error));
  }

  return LocaleKeys.somethingWentWrong.tr();
}

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

const int _maxMessageLength = 240;

String _orFallback(String message) {
  final String trimmed = message.trim();

  final bool isUsable =
      trimmed.isNotEmpty &&
      trimmed.length <= _maxMessageLength &&
      !trimmed.startsWith('<');

  if (isUsable) return trimmed;

  if (trimmed.isNotEmpty) {
    debugPrint('Discarded unusable error message: $trimmed');
  }

  return LocaleKeys.somethingWentWrong.tr();
}
