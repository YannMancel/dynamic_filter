import 'package:dynamic_filter/domain/specification/abstracts/composite_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/widgets/buttons/delete_icon_button.dart';
import 'package:dynamic_filter/presentation/widgets/rounded_decoration.dart';
import 'package:dynamic_filter/presentation/widgets/specifications/filter_logic_inherited_widget.dart';
import 'package:dynamic_filter/presentation/widgets/specifications/specification_add_widget.dart';
import 'package:dynamic_filter/presentation/widgets/specifications/specification_name_widget.dart';
import 'package:flutter/material.dart';

class SpecificationDeepDisplayWidget extends StatelessWidget {
  final Specification<int> _specification;

  const SpecificationDeepDisplayWidget(this._specification, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_specification.isComposite) {
      return _CompositeSpecificationWidget(_specification);
    }
    return _LeafSpecificationWidget(_specification);
  }
}

class _LeafSpecificationWidget extends StatelessWidget {
  final Specification<int> _specification;

  const _LeafSpecificationWidget(this._specification);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RoundedDecoration(
      color: Colors.white,
      child: Padding(
        padding: const .only(left: 16, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text('$_specification', style: textTheme.labelLarge),
            _SpecificationDeleteIconButton(_specification),
          ],
        ),
      ),
    );
  }
}

class _SpecificationDeleteIconButton extends StatelessWidget {
  final Specification<int> _specification;

  const _SpecificationDeleteIconButton(this._specification);

  @override
  Widget build(BuildContext context) {
    return DeleteIconButton(
      onPressed: () {
        final filterLogic = FilterLogicInheritedWidget.of(context).filterLogic;
        if (_specification.isRoot) {
          filterLogic.reset();
          return;
        }
        filterLogic.delete(_specification);
      },
    );
  }
}

class _CompositeSpecificationWidget extends StatelessWidget {
  final Specification<int> _specification;

  const _CompositeSpecificationWidget(this._specification);

  List<Specification<int>> get _components {
    return _specification is CompositeSpecification<int>
        ? _specification.components
        : const [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return RoundedDecoration(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const .only(left: 16, top: 16),
        child: Column(
          mainAxisSize: .min,
          children: [
            Row(
              children: [
                SpecificationNameWidget(_specification),
                Expanded(
                  child: Padding(
                    padding: const .only(left: 16),
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      spacing: 16,
                      children: [
                        for (final component in _components)
                          SpecificationDeepDisplayWidget(component),
                      ],
                    ),
                  ),
                ),
                _SpecificationDeleteIconButton(_specification),
              ],
            ),
            SpecificationAddWidget(specificationRoot: _specification),
          ],
        ),
      ),
    );
  }
}
