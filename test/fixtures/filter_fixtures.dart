import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/leaf_filter.dart';
import 'package:flutter/foundation.dart';

final equalTo5 = LeafFilter<int>((e) => e == 5, description: 'x = 5');
final higherThan6 = LeafFilter<int>((e) => e > 6, description: 'x > 6');
final lowerThan10 = LeafFilter<int>((e) => e < 10, description: 'x < 10');

extension FilterExt<T> on Filter<T> {
  String _tabulatedLabel(String label, int tabulationNumber) {
    return '${''.padLeft(tabulationNumber, '\t')}$label';
  }

  void toDeepString([int tabulationNumber = 0]) {
    if (this case CompositeFilter<T> composite) {
      debugPrint(
        _tabulatedLabel(
          '$runtimeType (${composite.components.length})',
          tabulationNumber,
        ),
      );
      for (final component in composite.components) {
        component.toDeepString(tabulationNumber + 1);
      }
      return;
    }
    debugPrint(_tabulatedLabel('$this', tabulationNumber));
  }
}
