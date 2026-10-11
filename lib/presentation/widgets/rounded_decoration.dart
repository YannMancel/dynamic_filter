import 'package:flutter/material.dart';

class RoundedDecoration extends StatelessWidget {
  final Color _color;
  final Widget _child;

  const RoundedDecoration({
    super.key,
    required this._color,
    required this._child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const .all(.circular(16)),
        border: .all(),
        color: _color,
      ),
      child: _child,
    );
  }
}
