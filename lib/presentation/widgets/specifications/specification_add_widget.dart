import 'package:dynamic_filter/domain/operations/arithmetic_operation.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/widgets/arithmetic_operations/arithmetic_operation_dropdown_button.dart';
import 'package:dynamic_filter/presentation/widgets/buttons/add_icon_button.dart';
import 'package:dynamic_filter/presentation/widgets/buttons/check_icon_button.dart';
import 'package:dynamic_filter/presentation/widgets/buttons/delete_icon_button.dart';
import 'package:dynamic_filter/presentation/widgets/rounded_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpecificationAddWidget extends StatefulWidget {
  final Specification<int>? _specificationRoot;

  const SpecificationAddWidget({super.key, this._specificationRoot});

  @override
  State<SpecificationAddWidget> createState() => _SpecificationAddWidgetState();
}

class _SpecificationAddWidgetState extends State<SpecificationAddWidget> {
  late bool _showAddButton;
  late ArithmeticOperation? _arithmeticOperation;
  late TextEditingController _textEditController;

  bool get _canAddSpecification {
    return _arithmeticOperation != null && _textEditController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _showAddButton = true;
    _arithmeticOperation = .equalTo;
    _textEditController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _showAddButton
        ? AddIconButton(onPressed: () => setState(() => _showAddButton = false))
        : RoundedDecoration(
            color: Colors.white,
            child: Padding(
              padding: const .only(left: 16),
              child: Row(
                children: [
                  ArithmeticOperationDropdownButton(
                    arithmeticOperation: _arithmeticOperation,
                    onChanged: (arithmeticOperation) {
                      setState(
                        () => _arithmeticOperation = arithmeticOperation,
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const .symmetric(horizontal: 16),
                      child: TextField(
                        controller: _textEditController,
                        style: textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Value',
                          hintStyle: textTheme.bodyMedium,
                          border: .none,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  DeleteIconButton(
                    onPressed: () => setState(() {
                      _showAddButton = true;
                      _arithmeticOperation = .equalTo;
                      _textEditController.clear();
                    }),
                  ),
                  CheckIconButton(
                    onPressed: _canAddSpecification
                        ? () {
                            // TODO widget._specificationRoot
                          }
                        : null,
                  ),
                ],
              ),
            ),
          );
  }
}
