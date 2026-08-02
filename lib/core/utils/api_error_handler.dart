import 'package:easy_localization/easy_localization.dart';
import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static String handle(Object error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;

        if (data is Map<String, dynamic>) {
          return data['message']?.toString() ?? LocaleKeys.serverError.tr();
        }

        return 'Server error';
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout';
        case DioExceptionType.sendTimeout:
          return 'Send timeout';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout';
        case DioExceptionType.connectionError:
          return 'No internet connection';
        default:
          return 'Unexpected error';
      }
    }

    return 'Something went wrong';
  }
}
