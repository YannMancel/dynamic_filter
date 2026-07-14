import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/state_machine/state_transition.dart';
import 'package:flutter/foundation.dart';

/// [AsyncValueTransition] is a sealed class which gathers __three exclusive
/// possibilities__.
///
/// `AsyncValueTransition<L, R>` = `LoadingAsyncValueTransition<L, R>` | `FailureAsyncValueTransition<L, R>` | `SuccessAsyncValueTransition<L, R>`
///
/// For example:
/// ```dart
/// final stateMachine = AsyncStateMachine.guarded(
///   () async => const IdleAsyncValue(),
///   transitionsByState: AsyncValueTransition.getTransitionsByState<Exception, List<int>>(),
///   onError: (error, _) async => FailureAsyncValue(
///     error is Exception ? error : Exception('$error'),
///   ),
/// );
///
/// final asyncValue = await stateMachine
///     .applyOrThrow(
///       (state) async => AsyncValueTransition.getTransitionToLoading(state),
///     )
///     .applyOrThrow(
///       (_) async => SuccessAsyncValueTransition(
///         List.unmodifiable(Iterable.generate(100, (index) => index + 1)),
///       ),
///     )
///     .state();
/// ```
@immutable
sealed class AsyncValueTransition<L, R>
    implements StateTransition<AsyncValue<L, R>> {
  const AsyncValueTransition();

  /// Get all permitted [AsyncValueTransition] for each [AsyncValue] variant.
  ///
  /// ```dart
  /// final stateMachine = AsyncStateMachine.guarded(
  ///   () async => const IdleAsyncValue(),
  ///   transitionsByState: AsyncValueTransition.getTransitionsByState<Exception, List<int>>(),
  ///   onError: (error, _) async => FailureAsyncValue(
  ///     error is Exception ? error : Exception('$error'),
  ///   ),
  /// );
  /// ```
  static Map<Type, Set<Type>> getTransitionsByState<L, R>() {
    return {
      IdleAsyncValue<L, R>: {LoadingAsyncValueTransition<L, R>},
      LoadingAsyncValue<L, R>: {
        LoadingAsyncValueTransition<L, R>,
        FailureAsyncValueTransition<L, R>,
        SuccessAsyncValueTransition<L, R>,
      },
      FailureAsyncValue<L, R>: {LoadingAsyncValueTransition<L, R>},
      SuccessAsyncValue<L, R>: {
        LoadingAsyncValueTransition<L, R>,
        SuccessAsyncValueTransition<L, R>,
      },
    };
  }
}

@immutable
final class LoadingAsyncValueTransition<L, R>
    extends AsyncValueTransition<L, R> {
  const LoadingAsyncValueTransition();

  @override
  AsyncValue<L, R> get nextState => LoadingAsyncValue<L, R>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingAsyncValueTransition && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

@immutable
final class FailureAsyncValueTransition<L, R>
    extends AsyncValueTransition<L, R> {
  const FailureAsyncValueTransition(this._value);

  final L _value;

  @override
  AsyncValue<L, R> get nextState => FailureAsyncValue<L, R>(_value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureAsyncValueTransition &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

@immutable
final class SuccessAsyncValueTransition<L, R>
    extends AsyncValueTransition<L, R> {
  const SuccessAsyncValueTransition(this._value);

  final R _value;

  @override
  AsyncValue<L, R> get nextState => SuccessAsyncValue<L, R>(_value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuccessAsyncValueTransition &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
