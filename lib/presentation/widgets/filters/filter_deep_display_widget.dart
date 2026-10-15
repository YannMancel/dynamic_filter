import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/presentation/widgets/buttons/delete_icon_button.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_add_widget.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_logic_inherited_widget.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_name_widget.dart';
import 'package:dynamic_filter/presentation/widgets/rounded_decoration.dart';
import 'package:flutter/material.dart';

class FilterDeepDisplayWidget extends StatelessWidget {
  final Filter<int> _filter;

  const FilterDeepDisplayWidget(this._filter, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_filter.isComposite) {
      return _CompositeFilterWidget(_filter);
    }
    return _LeafFilterWidget(_filter);
  }
}

class _LeafFilterWidget extends StatelessWidget {
  final Filter<int> _filter;

  const _LeafFilterWidget(this._filter);

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
            Text('$_filter', style: textTheme.labelLarge),
            _FilterDeleteIconButton(_filter),
          ],
        ),
      ),
    );
  }
}

class _FilterDeleteIconButton extends StatelessWidget {
  final Filter<int> _filter;

  const _FilterDeleteIconButton(this._filter);

  @override
  Widget build(BuildContext context) {
    return DeleteIconButton(
      onPressed: () {
        final filterLogic = FilterLogicInheritedWidget.of(context).filterLogic;
        if (_filter.isRoot) {
          filterLogic.reset();
          return;
        }
        filterLogic.delete(_filter);
      },
    );
  }
}

class _CompositeFilterWidget extends StatelessWidget {
  final Filter<int> _filter;

  const _CompositeFilterWidget(this._filter);

  List<Filter<int>> get _components {
    return _filter is CompositeFilter<int> ? _filter.components : const [];
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
                FilterNameWidget(_filter),
                Expanded(
                  child: Padding(
                    padding: const .only(left: 16),
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      spacing: 16,
                      children: [
                        for (final component in _components)
                          FilterDeepDisplayWidget(component),
                      ],
                    ),
                  ),
                ),
                _FilterDeleteIconButton(_filter),
              ],
            ),
            FilterAddWidget(rootFilter: _filter),
          ],
        ),
      ),
    );
  }
}
