import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/async_value/async_value_transition.dart';
import 'package:dynamic_filter/domain/state_machine/async_state_machine.dart';

typedef AsyncValueStateMachine<L, R> =
    AsyncStateMachine<AsyncValue<L, R>, AsyncValueTransition<L, R>>;
