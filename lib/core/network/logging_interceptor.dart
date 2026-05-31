import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Logs every Dio request, response, and error via [Logger].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor([Logger? logger]) : _log = logger ?? Logger();

  final Logger _log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.d('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.e('✗ ${err.requestOptions.uri}', error: err.message);
    handler.next(err);
  }
}
