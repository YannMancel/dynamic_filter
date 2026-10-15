import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_add_widget.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_deep_display_widget.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_logic_inherited_widget.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_value_listenable_builder.dart';
import 'package:dynamic_filter/presentation/widgets/filters/no_filter_widget.dart';
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
    return FilterLogicInheritedWidget(
      filterLogic: _logic,
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverPadding(
            padding: const .symmetric(horizontal: 16),
            sliver: FilterValueListenableBuilder(
              noFilter: (_) => const _NoFilterSliver(),
              filter: (_, filter) => _FilterSliver(filter),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoFilterSliver extends StatelessWidget {
  const _NoFilterSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [NoFilterWidget(), FilterAddWidget()],
        ),
      ),
    );
  }
}

class _FilterSliver extends StatelessWidget {
  final Filter<int> _filter;

  const _FilterSliver(this._filter);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: FilterDeepDisplayWidget(_filter));
  }
}
