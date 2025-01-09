// lib/core/network/dio_client.dart
//import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // For logging in debug mode

import '../../config/res/dims.dart';
import '../utils/app_logger.dart';
import 'status_code_handler.dart';

/*class DioClient {
  // Make `_instance` thread-safe with late initialization
  static final DioClient _instance = DioClient._internal();

  // Private constructor
  DioClient._internal() {
    Map<String, dynamic>? extras;
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      connectTimeout: const Duration(seconds: 10),  // Adjusted connect timeout
      receiveTimeout: const Duration(seconds: 10),  // Adjusted receive timeout
      headers: {
        'Content-Type': 'application/json', // Default content type header
      },

    ));

    // Adding extra interceptors for handling logging or other customization
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Modify request headers or params globally if necessary
        //options.headers['Authorization'] = 'Bearer your_api_token';
        logRequest('Response received:', handler.toString());
        handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        // Handle the response globally (e.g., logging)
        logResponse('Response received:', response.data);
        //log('Response received: ${response.data}');
        handler.next(response); // Continue with the response
      },
      onError: (DioError error, handler) {
        // Handle errors globally (e.g., retry logic, custom error messages)
        Logger().error('Response received: ${error.message}');
        //log('Error occurred: ${error.message}');
        handler.next(error); // Continue with the error
      },
    ));
  }

  // Factory constructor for singleton pattern
  factory DioClient() => _instance;

  late final Dio _dio;

  Dio get dio => _dio;

  // Method to perform a GET request with headers, query params, etc.
  Future<Response> getRequest(String endpoint, {Object? data, Map<String, dynamic>? queryParams, Map<String, dynamic>? headers,  void Function(int, int)? onReceiveProgress,}) async {
    Logger().info('Making GET request to: $endpoint');
    Map<String, dynamic>? extras;
    try {
      return await _dio.get(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: extras*//*{'extraKey': 'extraValue'}*//*, // Custom extras
        ),
        onReceiveProgress: onReceiveProgress,
      );

    } on DioError catch (e) {
      // Handle error
      Logger().error('Request failed with status: ${e.response?.statusCode}, message: ${e.message}');
      Logger().error('Error making GET request: $e');
      rethrow;
    }
  }

  // Method to perform a POST request with body, headers, etc.
  Future<Response> postRequest(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: {'extraKey': 'extraValue'}, // Custom extras
        ),
      );
    } on DioError catch (e) {
      // Handle error
      log('Request failed with status: ${e.response?.statusCode}, message: ${e.message}');
      Logger().error('Error making GET request: $e');
      rethrow;
    }
  }

  /// Log API request details
  void logRequest(String method, String url, {Map<String, dynamic>? body}) {
    Logger().info('API Request - Method: $method, URL: $url, Body: $body');
  }

  /// Logs the API response
  void logResponse(String url, dynamic response) {
    Logger().info('Response from $url: ${response.statusCode} ${response.body}');
  }
}*/

class DioClient {
  // Singleton instance
  static final DioClient _instance = DioClient._internal();

  // Private constructor
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl:'https://jsonplaceholder.typicode.com/',
        connectTimeout: const Duration(seconds: 5), // Connection timeout
        receiveTimeout: const Duration(seconds: 3), // Receive timeout
        headers: {
          'Content-Type': 'application/json', // Default content type header
        },
      ),
    );

    // Adding interceptors for logging or custom behavior
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Modify request globally (e.g., adding headers)
          if (kDebugMode) {
            final startTime = DateTime.now();
            options.extra['startTime'] = startTime;
            Logger().info("REQUEST [${options.method}] => PATH: ${options.path}");
            Logger().info("Headers: ${options.headers}");
            Logger().info("Request Body: ${options.data}");
            logRequest(options.method, options.uri.toString(), body: options.data);
          }
          return handler.next(options); // Continue the request
        },
        onResponse: (response, handler) {
          // Log response globally
          if (kDebugMode) {
            final startTime = response.requestOptions.extra['startTime'] as DateTime?;
            final endTime = DateTime.now();
            final duration = startTime != null ? endTime.difference(startTime) : null;

            Logger().info("RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}");
            Logger().info("Response Body: ${response.data}");
            if (duration != null) {
              Logger().info("Duration: ${duration.inMilliseconds} ms");
            }
            logResponse(response.requestOptions.uri.toString(), response);
          }
          return handler.next(response); // Continue with the response
        },
        onError: (error, handler) {
          // Handle errors globally
          if (kDebugMode) {
            Logger().error("ERROR [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}");
            Logger().error("Error Message: ${error.message}");
            Logger().error("Error Data: ${error.response?.data}");
            logError(error);
          }
          return handler.next(error); // Continue with the error
        },
      ),
    );
  }

  // Factory constructor
  factory DioClient() => _instance;

  late final Dio _dio;

  // Expose the Dio instance
  Dio get dio => _dio;

  // Perform a GET request
  Future<Response> getRequest(
      String endpoint, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        Object? data,
        void Function(int, int)? onReceiveProgress,
      }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
        onReceiveProgress: onReceiveProgress,
        data: data,
      );
    } on DioException catch (e) {
      // Log and rethrow the error
      logError(e);
      rethrow;
    }
  }

  // Perform a POST request
  Future<Response> postRequest(
      String endpoint, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
      }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );
    } on DioException catch (e) {
      // Log and rethrow the error
      logError(e);
      rethrow;
    }
  }

  Future<Response> putRequest(
      String endpoint, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
      }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );
    } on DioException catch (e) {
      logError(e);
      rethrow;
    }
  }

  Future<Response> patchRequest(
      String endpoint, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
      }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );
    } on DioException catch (e) {
      logError(e);
      rethrow;
    }
  }

  Future<Response> deleteRequest(
      String endpoint, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
      }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );
    } on DioException catch (e) {
      logError(e);
      rethrow;
    }
  }

  /// Log API request details
  void logRequest(String method, String url, {dynamic body}) {
    Logger().info('API Request - Method: $method, URL: $url, Body: $body');
  }

  /// Log API response details
  void logResponse(String url, Response response) {
    //Logger().info('API Response - URL: $url, Status Code: ${response.statusCode}, Data: ${response.data}',);
    Logger().info('API Response - URL: $url, Status Code: ${StatusCodeHandler().handleStatusCode(response.statusCode ?? Dim.intZero,)}, Message: ${response.statusMessage}, Response: ${response.data}',);
  }

  /// Log errors
  void logError(DioException error) {
    Logger().error('API Error - Status Code: ${StatusCodeHandler().handleDioError(error)}, Message: ${error.message}, Response: ${error.response?.data}',);
    // Use the singleton to handle errors
  }
}
