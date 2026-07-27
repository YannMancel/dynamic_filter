import 'dart:async';

import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:dynamic_filter/presentation/widgets/dynamic_filter_app.dart';
import 'package:dynamic_filter/presentation/widgets/values_page.dart';
import 'package:dynamic_filter/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/exception_fixtures.dart';
import '../../fixtures/fake_filter_logic_fixtures.dart';
import '../../fixtures/fake_values_logic_fixtures.dart';
import '../../fixtures/specification_fixtures.dart';
import '../../widget_tester_extension.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  setUp(() {
    getIt.pushNewScope();
  });

  tearDown(() async {
    await getIt.popScope();
  });

  Finder findListTileByValue(int value) {
    return find.descendant(
      of: find.byType(ListTile),
      matching: find.text('Value: $value'),
    );
  }

  testWidgets('Given the state of $ValuesLogic is a $SuccessAsyncValue '
      'When $ValuesPage is pump '
      'Then display the success widget', (tester) async {
    final completer = Completer<void>();
    getIt.registerFactory<ValuesLogic>(
      () => FakeValuesLogic(
        SuccessAsyncValue(itemsFrom1To20),
        onInitialize: () => completer.complete(),
      ),
    );

    await tester.pumpCustomWidget(const DynamicFilterApp());
    await tester.pump();

    expect(completer.isCompleted, isTrue);

    final firstListTileFinder = findListTileByValue(1);
    final lastListTileFinder = findListTileByValue(itemsFrom1To20.length);

    expect(firstListTileFinder, findsOneWidget);
    expect(lastListTileFinder, findsNothing);

    await tester.scrollUntilVisible(
      lastListTileFinder,
      500,
      scrollable: find.descendant(
        of: find.byType(ValuesPage),
        matching: find.byType(Scrollable),
      ),
    );

    expect(firstListTileFinder, findsNothing);
    expect(lastListTileFinder, findsOneWidget);
  });

  testWidgets('Given the state of $ValuesLogic is a $FailureAsyncValue '
      'When $ValuesPage is pump '
      'Then display the failure widget', (tester) async {
    final completer = Completer<void>();
    getIt.registerFactory<ValuesLogic>(
      () => FakeValuesLogic(
        FailureAsyncValue(fakeException),
        onInitialize: () => completer.complete(),
      ),
    );

    await tester.pumpCustomWidget(const DynamicFilterApp());
    await tester.pump();

    expect(completer.isCompleted, isTrue);
    expect(find.text('$fakeException'), findsOneWidget);
  });

  testWidgets('Given the state of $ValuesLogic is a $SuccessAsyncValue '
      'When $ValuesPage is pump '
      'And $FilterLogic update a $Specification '
      'Then display the success widget', (tester) async {
    final completer = Completer<void>();
    getIt.registerFactory<ValuesLogic>(
      () => FakeValuesLogic(
        SuccessAsyncValue(itemsFrom1To20),
        onInitialize: () => completer.complete(),
      ),
    );
    getIt.registerFactory<FilterLogic>(FakeFilterLogic.new);

    await tester.pumpCustomWidget(const DynamicFilterApp());
    await tester.pump();

    expect(completer.isCompleted, isTrue);
    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();

    expect(find.byType(ListTile), findsOneWidget);
    expect(findListTileByValue(5), findsOneWidget);
  });
}
