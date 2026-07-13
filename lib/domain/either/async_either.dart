import 'package:dynamic_filter/domain/either/either.dart';
import 'package:flutter/foundation.dart';

typedef _OnError<L> = Future<L> Function(dynamic error, StackTrace stackTrace);

/// [AsyncEither] allows to manage asynchronous [Either] via callback.
///
/// `AsyncEither<L, R>` = await `Either<L, R>`
///
/// For example:
/// ```dart
/// final AsyncEither<Exception, User> asyncEither = AsyncEither.guarded(
///   () async => RightEither(user),
///   onError: (error, _) async => error is Exception
///     ? error
///     : Exception('$error'),
/// );
///
/// final either = await asyncEither
///   .chain<int>(getAgeByUser)
///   .chain<bool>(isLowerThan18)
///   .run();
///
/// final message = either.fold<String>(
///   left: (exception) => 'Failure: $exception',
///   right: (isLowerThan18) => 'Success: $isLowerThan18',
/// );
/// ```
final class AsyncEither<L, R> {
  const AsyncEither(this._callback, {this._onError});

  const AsyncEither.guarded(this._callback, {required this._onError});

  final ValueGetter<Future<Either<L, R>>> _callback;
  final _OnError<L>? _onError;

  /// Allows to complete the [AsyncEither] to retrieve the asynchronous
  /// [Either].
  ///
  /// ```dart
  /// final either = await asyncEither.run();
  /// ```
  Future<Either<L, R>> run() {
    return _callback().catchError((error, stackTrace) async {
      final leftOrNull = await _onError?.call(error, stackTrace);
      if (leftOrNull == null) throw error;
      return LeftEither<L, R>(leftOrNull);
    });
  }

  /// According to the completion of [Either] variant, there is 2 possibilities.
  /// 1. Leaves the [LeftEither] unchanged.
  /// 2. Converts the [RightEither] to [Either].
  ///
  /// The right's type pass from R to R2.
  ///
  /// ```dart
  /// asyncEither
  ///   .chain<bool>(isLowerThan18)
  ///   .chain<void>(sendWarningEvent);
  /// ```
  AsyncEither<L, R2> chain<R2>(Future<Either<L, R2>> Function(R) callback) {
    return AsyncEither<L, R2>(
      () => _callback().then(
        (either) => either.fold(
          left: (value) => LeftEither(value),
          right: (value) => callback(value),
        ),
      ),
      onError: _onError,
    );
  }

  /// Allows to expose the current [Either] during chain processing without
  /// causing any side effects.
  ///
  /// ```dart
  /// asyncEither
  ///   .peek((either) => print('either: $either'))
  ///   .chain<bool>(isLowerThan18);
  /// ```
  AsyncEither<L, R> peek(ValueSetter<Either<L, R>> callback) {
    return AsyncEither<L, R>(
      () => _callback().then((either) => either.peek(callback)),
      onError: _onError,
    );
  }
}
