import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/impl/filter_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/filtered_values_logic.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/impl/filtered_values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/impl/values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:flutter/material.dart';

class ValuesPage extends StatefulWidget {
  const ValuesPage({super.key, required this._title});

  final String _title;

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
    _valuesLogic = ValuesLogicImpl()..initialize();
    _filterLogic = FilterLogicImpl();
    _filteredValuesLogic = FilteredValuesLogicImpl(
      valuesNotifier: _valuesLogic.notifier,
      filterNotifier: _filterLogic.notifier,
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
    return _LogicsInheritedWidget(
      filterLogic: _filterLogic,
      filteredValuesLogic: _filteredValuesLogic,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _AppBarSliver(title: widget._title),
            const _BodySliver(),
          ],
        ),
      ),
    );
  }
}

class _LogicsInheritedWidget extends InheritedWidget {
  const _LogicsInheritedWidget({
    required this._filterLogic,
    required this._filteredValuesLogic,
    required super.child,
  });

  final FilterLogic _filterLogic;
  final FilteredValuesLogic _filteredValuesLogic;

  static _LogicsInheritedWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LogicsInheritedWidget>();
  }

  static _LogicsInheritedWidget of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No _LogicsInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant _LogicsInheritedWidget oldWidget) {
    return _filterLogic != oldWidget._filterLogic ||
        _filteredValuesLogic != oldWidget._filteredValuesLogic;
  }
}

class _AppBarSliver extends StatelessWidget {
  const _AppBarSliver({required this._title});

  final String _title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(_title),
      pinned: true,
      actions: [
        IconButton(
          onPressed: _LogicsInheritedWidget.of(context)._filterLogic.update,
          icon: Icon(Icons.filter_list),
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
      valueListenable: _LogicsInheritedWidget.of(
        context,
      )._filteredValuesLogic.notifier,
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
  const _FailureSliver(this._exception);

  final Exception _exception;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const .all(16.0),
        child: Center(child: Text('$_exception', textAlign: .center)),
      ),
    );
  }
}

class _SuccessSliver extends StatelessWidget {
  const _SuccessSliver(this._values);

  final List<int> _values;

  @override
  Widget build(BuildContext context) {
    if (_values.isEmpty) {
      return const SliverFillRemaining(
        child: Padding(
          padding: .all(16.0),
          child: Center(child: Text('No value according to this filter')),
        ),
      );
    }
    return SliverPadding(
      padding: const .only(left: 16, right: 16, bottom: 16),
      sliver: SliverList.builder(
        itemBuilder: (context, index) => Padding(
          padding: const .only(top: 16.0),
          child: ListTile(title: Text('Value: ${_values[index]}')),
        ),
        itemCount: _values.length,
      ),
    );
  }
}
