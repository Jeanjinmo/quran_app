import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'logging_interceptor.dart';

/// Holds the app-wide [Dio] instance with base URL, timeouts, and
/// the logging interceptor pre-configured.
class DioClient {
  DioClient([Dio? dio]) : dio = dio ?? Dio() {
    this.dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10)
      ..interceptors.add(LoggingInterceptor());
  }

  /// The configured Dio instance used for all metadata API calls.
  final Dio dio;
}
