/// Exceptions thrown by datasources. The repository catches these
/// and converts them to typed [Failure] objects.
library;

/// Thrown when the remote API responds with a non-success status or malformed
/// payload. Carries an optional [message] for logging/diagnostics.
class ServerException implements Exception {
  const ServerException([this.message = '']);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when there is no usable network connection before a request is made.
class NetworkException implements Exception {
  const NetworkException([this.message = '']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown by the local datasource when reading/writing cached data fails.
class CacheException implements Exception {
  const CacheException([this.message = '']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
