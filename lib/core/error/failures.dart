import 'package:equatable/equatable.dart';

/// Typed errors surfaced to domain and presentation layers.
/// [message] is for diagnostics; user-facing copy comes from [AppLocalizations].
sealed class Failure extends Equatable {
  const Failure([this.message = '']);

  final String message;

  @override
  List<Object> get props => [message];
}

/// The API responded with an error status or unparseable body.
final class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// No internet connection was available before the request.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Audio playback failed (e.g. CDN 403 for an unavailable reciter, decode or
/// timeout error from just_audio).
final class AudioFailure extends Failure {
  const AudioFailure([super.message]);
}

/// Reading or writing local persisted data failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}
