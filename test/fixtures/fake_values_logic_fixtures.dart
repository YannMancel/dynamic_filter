import 'dart:async';

import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeValuesLogic implements ValuesLogic {
  final ValueNotifier<AsyncValue<Exception, List<int>>> _notifier;
  final VoidCallback? _onInitialize;

  FakeValuesLogic(
    AsyncValue<Exception, List<int>> initialState, {
    this._onInitialize,
  }) : _notifier = ValueNotifier(initialState);

  @override
  ValueNotifier<AsyncValue<Exception, List<int>>> get notifier => _notifier;

  @override
  Future<void> initialize() async {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    _onInitialize?.call();
  }

  @override
  void dispose() => _notifier.dispose();
}
