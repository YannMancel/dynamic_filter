import 'package:flutter/foundation.dart';

/// [Either] is an algebraic type that represents one of __two mutually
/// exclusive possibilities__, conventionally referred to as [LeftEither]
/// and [RightEither].
///
/// `Either<L, R>` = `LeftEither<L, R>` | `RightEither<L, R>`
///
/// By convention:
/// 1. [LeftEither] is the negative variant.
///     * Error,
///     * Alternative outcome
/// 2. [RightEither] is the positive variant (success, expected outcome).
///     * Success,
///     * Expected outcome
///
/// For example:
/// ```dart
/// const Either<Exception, User> either = RightEither(user);
///
/// final message = either
///   .map<int>((user) => user.age)
///   .map<bool>((age) => age < 18)
///   .fold<String>(
///     left: (exception) => 'Failure: $exception',
///     right: (isLowerThan18) => 'Success: $isLowerThan18',
///   );
/// ```
@immutable
sealed class Either<L, R> {
  const Either();

  bool get isLeft {
    return switch (this) {
      LeftEither<L, R>() => true,
      RightEither<L, R>() => false,
    };
  }

  bool get isRight => !isLeft;

  /// Converts each [Either] variant to an another Object.
  ///
  /// ```dart
  /// print(
  ///   either.fold<String>(
  ///     left: (value) => 'Failure: $value',
  ///     right: (value) => 'Success: $value',
  ///   ),
  /// );
  /// ```
  T fold<T>({required T Function(L) left, required T Function(R) right}) {
    return switch (this) {
      LeftEither<L, R>(:final _value) => left(_value),
      RightEither<L, R>(:final _value) => right(_value),
    };
  }

  /// According to the [Either] variant, there is 2 possibilities.
  /// 1. Leaves the [LeftEither] unchanged.
  /// 2. Converts the [RightEither] to another [RightEither].
  ///
  /// The right's type pass from R to R2.
  ///
  /// ```dart
  /// either
  ///   .map<int>((user) => user.age)
  ///   .map<bool>((age) => age < 18);
  /// ```
  Either<L, R2> map<R2>(R2 Function(R) callback) {
    return switch (this) {
      LeftEither<L, R>(:final _value) => LeftEither<L, R2>(_value),
      RightEither<L, R>(:final _value) => RightEither<L, R2>(callback(_value)),
    };
  }

  /// According to [Either] variant, there is 2 possibilities.
  /// 1. Converts the [LeftEither] to another [LeftEither].
  /// 2. Converts the [RightEither] to another [RightEither].
  ///
  /// The left's type pass from L to L2.
  /// The right's type pass from R to R2.
  ///
  /// ```dart
  /// either
  ///   .flatMap<User>((userId) => getUser(userId))
  ///   .biMap<Exception, int>(
  ///     left: (value) => DomainException('getUser is fail'),
  ///     right: (user) => user.age,
  ///   );
  /// ```
  Either<L2, R2> biMap<L2, R2>({
    required L2 Function(L) left,
    required R2 Function(R) right,
  }) {
    return switch (this) {
      LeftEither<L, R>(:final _value) => LeftEither<L2, R2>(left(_value)),
      RightEither<L, R>(:final _value) => RightEither<L2, R2>(right(_value)),
    };
  }

  /// According to the [Either] variant, there is 2 possibilities.
  /// 1. Leaves the [LeftEither] unchanged.
  /// 2. Converts the [RightEither] to [Either].
  ///
  /// The right's type pass from R to R2.
  ///
  /// ```dart
  /// either
  ///   .flatMap<bool>(isLowerThan18)
  ///   .flatMap<void>(sendWarningEvent);
  /// ```
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) callback) {
    return switch (this) {
      LeftEither<L, R>(:final _value) => LeftEither<L, R2>(_value),
      RightEither<L, R>(:final _value) => callback(_value),
    };
  }

  /// Allows to expose the current [Either] during chain processing without
  /// causing any side effects.
  ///
  /// ```dart
  /// either
  ///   .peek((either) => print('either: $either'))
  ///   .flatMap<bool>(isLowerThan18);
  /// ```
  Either<L, R> peek(ValueSetter<Either<L, R>> callback) {
    callback(this);
    return this;
  }
}

/// By convention, [LeftEither] is the negative variant.
@immutable
final class LeftEither<L, R> extends Either<L, R> {
  const LeftEither(this._value);

  final L _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeftEither &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

/// By convention, [RightEither] is the positive variant.
@immutable
final class RightEither<L, R> extends Either<L, R> {
  const RightEither(this._value);

  final R _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RightEither &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
