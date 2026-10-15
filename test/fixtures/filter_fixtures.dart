import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/leaf_filter.dart';
import 'package:flutter/foundation.dart';

// Into parent filter, each child filter has an inner state.
// To avoid side effect, do not use final variable but use factory method.

Filter<int> getEqualTo5() {
  return LeafFilter<int>((e) => e == 5, description: 'x = 5');
}

Filter<int> getHigherThan6() {
  return LeafFilter<int>((e) => e > 6, description: 'x > 6');
}

Filter<int> getLowerThan10() {
  return LeafFilter<int>((e) => e < 10, description: 'x < 10');
}

extension FilterExt<T> on Filter<T> {
  String _tabulatedLabel(String label, int tabulationNumber) {
    return '${''.padLeft(tabulationNumber, '\t')}$label';
  }

  void toDeepString([int tabulationNumber = 0]) {
    if (this is LeafFilter<T>) {
      debugPrint(_tabulatedLabel('$this', tabulationNumber));
      return;
    }

    if (isComposite) {
      final components = (this as CompositeFilter<T>).components;
      debugPrint(
        _tabulatedLabel(
          '$runtimeType (${components.length})',
          tabulationNumber,
        ),
      );
      for (final component in components) {
        component.toDeepString(tabulationNumber + 1);
      }
    }
  }
}

final itemsFrom1To20 = List<int>.unmodifiable(
  List.generate(20, (index) => index + 1),
);
