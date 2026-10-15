import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_logic_inherited_widget.dart';
import 'package:flutter/material.dart';

class FilterValueListenableBuilder extends StatelessWidget {
  const FilterValueListenableBuilder({
    super.key,
    required this._noFilter,
    required this._filter,
  });

  final WidgetBuilder _noFilter;
  final Widget Function(BuildContext, Filter<int>) _filter;

  @override
  Widget build(BuildContext context) {
    final filterLogic = FilterLogicInheritedWidget.of(context).filterLogic;
    return ValueListenableBuilder(
      valueListenable: filterLogic.notifier,
      builder: (context, filter, _) {
        return filter != null ? _filter(context, filter) : _noFilter(context);
      },
    );
  }
}
