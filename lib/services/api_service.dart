import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  ApiService() {
    _initDio();
  }
  late Dio _dio;

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://reqres.in/api/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
      ),
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          debugPrint('Sending request to ${options.path}');
          options.headers['X-Demo'] = 'Interceptor-Test';
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          debugPrint('Response received: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          debugPrint('Error occurred: ${error.message}');
          return handler.next(error);
        },
      ),
    ]);
  }

  Future<dynamic> getUsers() async {
    try {
      final response = await _dio.get('users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createUser(String name, String job) async {
    try {
      final response = await _dio.post(
        'users',
        data: {'name': name, 'job': job},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
