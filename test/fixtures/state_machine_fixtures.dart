import 'package:dynamic_filter/domain/state_machine/state_transition.dart';
import 'package:flutter/foundation.dart';

void debugPrintState<S>(S state) => debugPrint('State: $state');

sealed class FakeStringTransition implements StateTransition<String> {
  const FakeStringTransition();
}

final class ToB extends FakeStringTransition {
  const ToB();

  @override
  String get nextState => 'B';
}

final class ToC extends FakeStringTransition {
  const ToC();

  @override
  String get nextState => 'C';
}

final class ToD extends FakeStringTransition {
  const ToD();

  @override
  String get nextState => 'D';
}
