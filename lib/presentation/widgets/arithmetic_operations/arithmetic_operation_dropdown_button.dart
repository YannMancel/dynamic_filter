import 'package:dynamic_filter/domain/operations/arithmetic_operation.dart';
import 'package:dynamic_filter/presentation/widgets/arithmetic_operations/arithmetic_operation_name_widget.dart';
import 'package:flutter/material.dart';

class ArithmeticOperationDropdownButton extends StatelessWidget {
  final ArithmeticOperation? _arithmeticOperation;
  final ValueSetter<ArithmeticOperation?>? _onChanged;

  const ArithmeticOperationDropdownButton({
    super.key,
    this._arithmeticOperation,
    this._onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ArithmeticOperation>(
      value: _arithmeticOperation,
      items: [
        for (final arithmeticOperation in ArithmeticOperation.values)
          DropdownMenuItem<ArithmeticOperation>(
            value: arithmeticOperation,
            child: ArithmeticOperationNameWidget(arithmeticOperation),
          ),
      ],
      onChanged: _onChanged,
    );
  }
}
