import 'package:dynamic_filter/domain/specification/abstracts/composite_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final FilterLogic _logic;
  final ScrollController _controller;

  const FilterBottomSheet(this._logic, this._controller, {super.key});

  static Future<void> show(
    BuildContext context, {
    Key? key,
    required FilterLogic logic,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        key: key,
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.85,
        builder: (_, controller) => FilterBottomSheet(logic, controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _LogicInheritedWidget(
      filterLogic: _logic,
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          _SpecificationValueListenableBuilder(
            noFilter: (_) => const _NoFilterSliver(),
            filter: (_, specification) => _FilterSliver(specification),
          ),
        ],
      ),
    );
  }
}

class _LogicInheritedWidget extends InheritedWidget {
  final FilterLogic _filterLogic;

  const _LogicInheritedWidget({
    required this._filterLogic,
    required super.child,
  });

  static _LogicInheritedWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LogicInheritedWidget>();
  }

  static _LogicInheritedWidget of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No _LogicInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant _LogicInheritedWidget oldWidget) {
    return _filterLogic != oldWidget._filterLogic;
  }
}

class _SpecificationValueListenableBuilder extends StatelessWidget {
  const _SpecificationValueListenableBuilder({
    required this._noFilter,
    required this._filter,
  });

  final WidgetBuilder _noFilter;
  final Widget Function(BuildContext, Specification<int>) _filter;

  @override
  Widget build(BuildContext context) {
    final filterLogic = _LogicInheritedWidget.of(context)._filterLogic;
    return ValueListenableBuilder(
      valueListenable: filterLogic.notifier,
      builder: (context, specificationOrNull, _) {
        return specificationOrNull != null
            ? _filter(context, specificationOrNull)
            : _noFilter(context);
      },
    );
  }
}

class _NoFilterSliver extends StatelessWidget {
  const _NoFilterSliver();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SliverFillRemaining(
      child: Center(child: Text('No filter', style: textTheme.bodyMedium)),
    );
  }
}

class _FilterSliver extends StatelessWidget {
  final Specification<int> _specification;

  const _FilterSliver(this._specification);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .only(left: 16, right: 16, bottom: 16),
      sliver: SliverToBoxAdapter(child: _SpecificationWidget(_specification)),
    );
  }
}

class _SpecificationWidget extends StatelessWidget {
  final Specification<int> _specification;

  const _SpecificationWidget(this._specification);

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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(),
        color: Colors.white,
      ),
      child: Padding(
        padding: const .only(left: 16, top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(_specification.toString(), style: textTheme.labelLarge),
            _DeleteIconButton(_specification),
          ],
        ),
      ),
    );
  }
}

class _DeleteIconButton extends StatelessWidget {
  final Specification<int> _specification;

  const _DeleteIconButton(this._specification);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final filterLogic = _LogicInheritedWidget.of(context)._filterLogic;
        if (_specification.isRoot) {
          filterLogic.reset();
          return;
        }
        filterLogic.delete(_specification);
      },
      icon: Icon(Icons.delete),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(),
        color: colorScheme.primaryContainer,
      ),
      child: Padding(
        padding: const .only(left: 16, top: 16, bottom: 16),
        child: Row(
          children: [
            _LabelWidget(_specification),
            Expanded(
              child: Padding(
                padding: const .only(left: 16),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  spacing: 16,
                  children: [
                    for (final component in _components)
                      _SpecificationWidget(component),
                  ],
                ),
              ),
            ),
            _DeleteIconButton(_specification),
          ],
        ),
      ),
    );
  }
}

class _LabelWidget extends StatelessWidget {
  final Specification<int> _specification;

  const _LabelWidget(this._specification);

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
