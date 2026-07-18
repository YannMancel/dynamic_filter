import 'package:dynamic_filter/presentation/widgets/dynamic_filter_app.dart';
import 'package:dynamic_filter/presentation/widgets/values_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../widget_tester_extension.dart';

void main() {
  Finder findListTileByValue(int value) {
    return find.descendant(
      of: find.byType(ListTile),
      matching: find.text('Value: $value'),
    );
  }

  testWidgets('Should display the values', (tester) async {
    await tester.pumpCustomWidget(const DynamicFilterApp());
    await tester.pumpAndSettle();

    final firstListTileFinder = findListTileByValue(1);
    final lastListTileFinder = findListTileByValue(100);

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
}
