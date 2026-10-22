import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/filtered_values_logic.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:dynamic_filter/presentation/widgets/filter_bottom_sheet.dart';
import 'package:dynamic_filter/presentation/widgets/filters/filter_logic_inherited_widget.dart';
import 'package:dynamic_filter/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

class ValuesPage extends StatefulWidget {
  final String _title;

  const ValuesPage({super.key, required this._title});

  @override
  State<ValuesPage> createState() => _ValuesPageState();
}

class _ValuesPageState extends State<ValuesPage> {
  late ValuesLogic _valuesLogic;
  late FilterLogic _filterLogic;
  late FilteredValuesLogic _filteredValuesLogic;

  @override
  void initState() {
    super.initState();
    _valuesLogic = getIt<ValuesLogic>()..initialize();
    _filterLogic = getIt<FilterLogic>();
    _filteredValuesLogic = getIt<FilteredValuesLogic>(
      param1: _valuesLogic.notifier,
      param2: _filterLogic.notifier,
    )..initialize();
  }

  @override
  void dispose() {
    _filteredValuesLogic.dispose();
    _valuesLogic.dispose();
    _filterLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FilteredValuesLogicInheritedWidget(
      logic: _filteredValuesLogic,
      child: FilterLogicInheritedWidget(
        logic: _filterLogic,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              _AppBarSliver(title: widget._title),
              const _BodySliver(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilteredValuesLogicInheritedWidget extends InheritedWidget {
  final FilteredValuesLogic _logic;

  const _FilteredValuesLogicInheritedWidget({
    required this._logic,
    required super.child,
  });

  static _FilteredValuesLogicInheritedWidget? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
          _FilteredValuesLogicInheritedWidget
        >();
  }

  static _FilteredValuesLogicInheritedWidget of(BuildContext context) {
    final result = maybeOf(context);
    assert(
      result != null,
      'No _FilteredValuesLogicInheritedWidget found in context',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(
    covariant _FilteredValuesLogicInheritedWidget oldWidget,
  ) {
    return _logic != oldWidget._logic;
  }
}

class _AppBarSliver extends StatelessWidget {
  final String _title;

  const _AppBarSliver({required this._title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(_title),
      pinned: true,
      actions: [
        IconButton(
          onPressed: FilterLogicInheritedWidget.of(
            context,
          ).logic.filterByDefault,
          icon: Icon(Icons.filter_list),
        ),
        IconButton(
          onPressed: () async {
            await FilterBottomSheet.show(
              context,
              logic: FilterLogicInheritedWidget.of(context).logic,
            );
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}

class _BodySliver extends StatelessWidget {
  const _BodySliver();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _FilteredValuesLogicInheritedWidget.of(
        context,
      )._logic.notifier,
      builder: (_, asyncValue, _) => asyncValue.when(
        idle: () => const _IdleSliver(),
        loading: () => const _LoadingSliver(),
        failure: (exception) => _FailureSliver(exception),
        success: (values) => _SuccessSliver(values),
      ),
    );
  }
}

class _IdleSliver extends StatelessWidget {
  const _IdleSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(child: SizedBox.shrink());
  }
}

class _LoadingSliver extends StatelessWidget {
  const _LoadingSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _FailureSliver extends StatelessWidget {
  final Exception _exception;

  const _FailureSliver(this._exception);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SliverFillRemaining(
      child: Padding(
        padding: const .all(16.0),
        child: Center(
          child: Text(
            '$_exception',
            textAlign: .center,
            style: textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}

class _SuccessSliver extends StatelessWidget {
  final List<int> _values;

  const _SuccessSliver(this._values);

  @override
  Widget build(BuildContext context) {
    if (_values.isEmpty) return const _NoValueSliver();
    final textTheme = Theme.of(context).textTheme;
    return SliverPadding(
      padding: const .only(left: 16, right: 16, bottom: 16),
      sliver: SliverList.builder(
        itemBuilder: (context, index) => Padding(
          padding: const .only(top: 16.0),
          child: ListTile(
            title: Text(
              'Value: ${_values[index]}',
              style: textTheme.labelLarge,
            ),
          ),
        ),
        itemCount: _values.length,
      ),
    );
  }
}

class _NoValueSliver extends StatelessWidget {
  const _NoValueSliver();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SliverFillRemaining(
      child: Padding(
        padding: const .all(16.0),
        child: Center(child: Text('No value', style: textTheme.labelLarge)),
      ),
    );
  }
}
