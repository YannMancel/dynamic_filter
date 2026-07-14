import 'package:flutter/foundation.dart';

/// [AsyncValue] is a sealed class which gathers __four exclusive
/// possibilities__.
///
/// `AsyncValue<L, R>` = `IdleAsyncValue<L, R>` | `LoadingAsyncValue<L, R>` | `FailureAsyncValue<L, R>` | `SuccessAsyncValue<L, R>`
///
/// For example:
/// ```dart
/// const AsyncValue<Exception, User> asyncValue = SuccessAsyncValue(user);
///
/// final message = asyncValue.when<String>(
///   idle: () => 'Idle',
///   loading: () => 'Loading',
///   failure: (exception) => 'Failure: $exception',
///   success: (user) => 'Success: $user',
/// );
/// ```
@immutable
sealed class AsyncValue<L, R> {
  const AsyncValue();

  /// Converts each [AsyncValue] variant to an another Object.
  ///
  /// ```dart
  /// // For an AsyncValue<Exception, User>
  /// final message = asyncValue.when<String>(
  ///   idle: () => 'Idle',
  ///   loading: () => 'Loading',
  ///   failure: (exception) => 'Failure: $exception',
  ///   success: (user) => 'Success: $user',
  /// );
  /// ```
  T when<T>({
    required ValueGetter<T> idle,
    required ValueGetter<T> loading,
    required T Function(L) failure,
    required T Function(R) success,
  }) {
    return switch (this) {
      IdleAsyncValue<L, R>() => idle(),
      LoadingAsyncValue<L, R>() => loading(),
      FailureAsyncValue<L, R>(:final value) => failure(value),
      SuccessAsyncValue<L, R>(:final value) => success(value),
    };
  }

  /// Converts to an another Object:
  /// - either use the variant callbacks (as [when] method)
  /// - or use the orElse callback.
  ///
  /// The variant callbacks take precedence over the orElse callback.
  /// The orElse callback avoids the need to specify all [AsyncValue] variants.
  ///
  /// ```dart
  /// // For an AsyncValue<Exception, User>
  /// final message = asyncValue.maybeWhen<String>(
  ///   failure: (exception) => 'Failure: $exception',
  ///   orElse: () => 'Happy path',
  /// );
  /// ```
  T maybeWhen<T>({
    ValueGetter<T>? idle,
    ValueGetter<T>? loading,
    T Function(L)? failure,
    T Function(R)? success,
    required ValueGetter<T> orElse,
  }) {
    return switch (this) {
      IdleAsyncValue<L, R>() => idle != null ? idle() : orElse(),
      LoadingAsyncValue<L, R>() => loading != null ? loading() : orElse(),
      FailureAsyncValue<L, R>(:final value) =>
        failure != null ? failure(value) : orElse(),
      SuccessAsyncValue<L, R>(:final value) =>
        success != null ? success(value) : orElse(),
    };
  }
}

@immutable
final class IdleAsyncValue<L, R> extends AsyncValue<L, R> {
  const IdleAsyncValue();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleAsyncValue && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'IdleAsyncValue<$L, $R>';
}

@immutable
final class LoadingAsyncValue<L, R> extends AsyncValue<L, R> {
  const LoadingAsyncValue();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingAsyncValue && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'LoadingAsyncValue<$L, $R>';
}

@immutable
final class FailureAsyncValue<L, R> extends AsyncValue<L, R> {
  const FailureAsyncValue(this.value);

  @visibleForTesting
  final L value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureAsyncValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'FailureAsyncValue<$L, $R>{value: $value}';
}

@immutable
final class SuccessAsyncValue<L, R> extends AsyncValue<L, R> {
  const SuccessAsyncValue(this.value);

  @visibleForTesting
  final R value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuccessAsyncValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'SuccessAsyncValue<$L, $R>{value: $value}';
}
