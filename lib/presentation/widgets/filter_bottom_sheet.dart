import 'package:dynamic_filter/domain/specification/impl/leaf_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static Future<void> show(
    BuildContext context, {
    required ValueSetter<Specification<int>> onChange,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text('hello'),
            FilledButton(
              onPressed: () {
                onChange(LeafSpecification<int>((e) => e == 5));
              },
              child: Text('Accept'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(children: [Text('hello')]),
    );
  }
}
