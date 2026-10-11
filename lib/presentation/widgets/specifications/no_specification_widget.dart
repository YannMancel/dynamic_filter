import 'package:flutter/material.dart';

class NoSpecificationWidget extends StatelessWidget {
  const NoSpecificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text('No filter', style: textTheme.bodyMedium);
  }
}
