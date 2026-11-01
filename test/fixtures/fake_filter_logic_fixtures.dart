import 'dart:async';

import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/rule/filter_extension.dart';
import 'package:dynamic_filter/domain/rule/filter_request.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'filter_fixtures.dart';

final class FakeFilterLogic implements FilterLogic {
  final ValueNotifier<Filter<int>?> _notifier;

  FakeFilterLogic({Filter<int>? initialState})
    : _notifier = ValueNotifier(initialState);

  @override
  ValueNotifier<Filter<int>?> get notifier => _notifier;

  @override
  Future<void> filterByDefault() async {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    _notifier.value = equalTo5;
  }

  @override
  void delete(Filter<int> filter) {
    _notifier.value = _notifier.value
        ?.convertToRuleUntilTarget(filter)
        ?.handle(DeleteFilterRequest(filter))
        .when(
          empty: () => null,
          same: (filter) => filter,
          update: (filter) => filter,
        );
  }

  @override
  void dispose() => _notifier.dispose();
}
