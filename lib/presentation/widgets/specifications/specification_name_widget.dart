import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:flutter/material.dart';

class SpecificationNameWidget extends StatelessWidget {
  final Specification<int> _specification;

  const SpecificationNameWidget(this._specification, {super.key});

  String get _label {
    return _specification.isAndComposite
        ? 'AND'
        : _specification.isOrComposite
        ? 'OR'
        : _specification.runtimeType.toString();
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
