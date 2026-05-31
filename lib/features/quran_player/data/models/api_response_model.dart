import '../../../../core/error/exceptions.dart';

/// Generic wrapper for the Al-Quran Cloud response envelope: `{code, status, data}`.
/// [fromData] parses the `data` field so one class handles all endpoint shapes.
class ApiResponseModel<T> {
  const ApiResponseModel({
    required this.code,
    required this.status,
    required this.data,
  });

  final int code;
  final String status;
  final T data;

  /// Parses the envelope and delegates the `data` field to [fromData].
  ///
  /// Throws [ServerException] when the payload isn't the expected shape or the
  /// API reports a non-200 code — the data layer's job is to fail loudly here so
  /// the repository can convert it to a typed `Failure`.
  factory ApiResponseModel.fromJson(
    Object? json,
    T Function(Object? data) fromData,
  ) {
    if (json is! Map<String, dynamic>) {
      throw const ServerException('Unexpected response shape');
    }
    final code = json['code'];
    if (code is! int || code != 200) {
      throw ServerException('API returned code $code');
    }
    return ApiResponseModel<T>(
      code: code,
      status: json['status'] as String? ?? '',
      data: fromData(json['data']),
    );
  }
}
