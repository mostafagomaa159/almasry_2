
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

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
