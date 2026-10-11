import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/widgets/specifications/filter_logic_inherited_widget.dart';
import 'package:flutter/material.dart';

class SpecificationValueListenableBuilder extends StatelessWidget {
  const SpecificationValueListenableBuilder({
    super.key,
    required this._noFilter,
    required this._filter,
  });

  final WidgetBuilder _noFilter;
  final Widget Function(BuildContext, Specification<int>) _filter;

  @override
  Widget build(BuildContext context) {
    final filterLogic = FilterLogicInheritedWidget.of(context).filterLogic;
    return ValueListenableBuilder(
      valueListenable: filterLogic.notifier,
      builder: (context, specificationOrNull, _) {
        return specificationOrNull != null
            ? _filter(context, specificationOrNull)
            : _noFilter(context);
      },
    );
  }
}
