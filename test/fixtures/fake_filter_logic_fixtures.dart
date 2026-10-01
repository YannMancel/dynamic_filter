import 'dart:async';

import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'specification_fixtures.dart';

final class FakeFilterLogic implements FilterLogic {
  final ValueNotifier<Specification<int>?> _notifier;

  FakeFilterLogic({Specification<int>? initialState})
    : _notifier = ValueNotifier(initialState);

  @override
  ValueNotifier<Specification<int>?> get notifier => _notifier;

  @override
  Future<void> filterByDefault() async {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    _notifier.value = getEqualTo5();
  }

  @override
  void delete(Specification<int> specification) {
    specification.handle(DeleteSpecificationRequest(specification));
    // ignore: invalid_use_of_protected_member
    (_notifier as ChangeNotifier).notifyListeners();
  }

  @override
  void reset() => _notifier.value = null;

  @override
  void dispose() => _notifier.dispose();
}
