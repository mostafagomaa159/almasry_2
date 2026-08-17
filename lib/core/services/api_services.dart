import 'package:almasry_2/core/constants/app_api.dart';
import 'package:dio/dio.dart';
import 'package:almasry_2/core/constants/app_durations.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: AppDurations.networkTimeout,
      receiveTimeout: AppDurations.networkTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.token}',
      },
    ),
  );

  Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      endPoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(
      endPoint,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
