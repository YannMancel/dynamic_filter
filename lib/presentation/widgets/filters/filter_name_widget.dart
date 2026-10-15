import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/material.dart';

class FilterNameWidget extends StatelessWidget {
  final Filter<int> _filter;

  const FilterNameWidget(this._filter, {super.key});

  String get _label {
    return _filter.isAndComposite
        ? 'AND'
        : _filter.isOrComposite
        ? 'OR'
        : _filter.runtimeType.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      _label,
      style: textTheme.bodyMedium?.copyWith(fontWeight: .bold),
    );
  }
}
