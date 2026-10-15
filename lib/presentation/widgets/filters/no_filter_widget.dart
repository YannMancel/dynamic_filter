import 'package:flutter/material.dart';

class NoFilterWidget extends StatelessWidget {
  const NoFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text('No filter', style: textTheme.bodyMedium);
  }
}
