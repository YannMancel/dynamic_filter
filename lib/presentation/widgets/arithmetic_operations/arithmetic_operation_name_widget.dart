import 'package:dynamic_filter/domain/operations/arithmetic_operation.dart';
import 'package:flutter/material.dart';

class ArithmeticOperationNameWidget extends StatelessWidget {
  final ArithmeticOperation _arithmeticOperation;

  const ArithmeticOperationNameWidget(this._arithmeticOperation, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(switch (_arithmeticOperation) {
      ArithmeticOperation.equalTo => 'Equal To',
      ArithmeticOperation.lowerThan => 'Lower Than',
      ArithmeticOperation.higherThan => 'Higher Than',
    }, style: textTheme.bodyMedium);
  }
}
