import '../error/failures.dart';

/// Lightweight success-or-failure wrapper used at the repository boundary.
/// Sealed so `switch` over [Ok]/[Err] is exhaustive at compile time.
///
/// ```dart
/// switch (result) {
///   case Ok(:final value): // use value
///   case Err(:final failure): // emit error state
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// `true` when this is an [Ok]. Prefer pattern matching; this is a
  /// convenience for simple guard checks.
  bool get isOk => this is Ok<T>;

  /// Returns the success value or `null` when this is an [Err].
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };
}

/// The success case, carrying a [value] of type [T].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// The failure case, carrying a typed [failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
