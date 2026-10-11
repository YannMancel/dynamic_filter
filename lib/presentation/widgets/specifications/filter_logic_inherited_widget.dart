import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/material.dart';

class FilterLogicInheritedWidget extends InheritedWidget {
  final FilterLogic filterLogic;

  const FilterLogicInheritedWidget({
    super.key,
    required this.filterLogic,
    required super.child,
  });

  static FilterLogicInheritedWidget? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FilterLogicInheritedWidget>();
  }

  static FilterLogicInheritedWidget of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No FilterLogicInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant FilterLogicInheritedWidget oldWidget) {
    return filterLogic != oldWidget.filterLogic;
  }
}
