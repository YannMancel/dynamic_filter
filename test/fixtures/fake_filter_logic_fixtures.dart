import 'dart:async';

import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'specification_fixtures.dart';

final class FakeFilterLogic implements FilterLogic {
  FakeFilterLogic({Specification<int>? initialState})
    : _notifier = ValueNotifier(initialState);

  final ValueNotifier<Specification<int>?> _notifier;

  @override
  ValueNotifier<Specification<int>?> get notifier => _notifier;

  @override
  Future<void> update() async {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    _notifier.value = getEqualTo5();
  }

  @override
  void dispose() {}
}
