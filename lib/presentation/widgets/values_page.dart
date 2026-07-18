import 'package:dynamic_filter/presentation/logics/implementations/values_logic_by_value_notifier.dart';
import 'package:dynamic_filter/presentation/logics/values_logic.dart';
import 'package:flutter/material.dart';

class ValuesPage extends StatefulWidget {
  const ValuesPage({super.key, required this._title});

  final String _title;

  @override
  State<ValuesPage> createState() => _ValuesPageState();
}

class _ValuesPageState extends State<ValuesPage> {
  late ValuesLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = ValuesLogicByValueNotifier()..initialize();
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBarSliver(title: widget._title),
          ValueListenableBuilder(
            valueListenable: _logic.notifier,
            builder: (_, asyncValue, _) => asyncValue.when(
              idle: () => const _IdleSliver(),
              loading: () => const _LoadingSliver(),
              failure: (exception) => _FailureSliver(exception),
              success: (values) => _SuccessSliver(values),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logic.filter(),
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}

class _AppBarSliver extends StatelessWidget {
  const _AppBarSliver({required this._title});

  final String _title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(title: Text(_title), pinned: true);
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
