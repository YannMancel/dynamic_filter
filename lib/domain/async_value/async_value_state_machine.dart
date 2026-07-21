import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/async_value/async_value_transition.dart';
import 'package:dynamic_filter/domain/state_machine/async_state_machine.dart';

typedef AsyncValueStateMachine<L, R> =
    AsyncStateMachine<AsyncValue<L, R>, AsyncValueTransition<L, R>>;

AsyncValueStateMachine<L, R> generateAsyncValueStateMachine<L, R>(
  AsyncValue<L, R> value, {
  required Future<FailureAsyncValue<L, R>> Function(dynamic, StackTrace)?
  onError,
}) {
  return AsyncValueStateMachine<L, R>.guarded(
    () async => value,
    transitionsByState: AsyncValueTransition.getTransitionsByState<L, R>(),
    onError: onError,
  );
}
