import 'package:dynamic_filter/domain/specification/abstracts/composite_specification.dart';
import 'package:dynamic_filter/domain/specification/impl/leaf_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:flutter/foundation.dart';

// Into parent specification, each child specification has an inner state.
// To avoid side effect, do not use final variable but use factory method.
LeafSpecification<int> getEqualTo5() {
  return LeafSpecification<int>((e) => e == 5, description: 'x = 5');
}

LeafSpecification<int> getHigherThan6() {
  return LeafSpecification<int>((e) => e > 6, description: 'x > 6');
}

LeafSpecification<int> getLowerThan10() {
  return LeafSpecification<int>((e) => e < 10, description: 'x < 10');
}

extension SpecificationExt<T> on Specification<T> {
  String _tabulatedLabel(String label, int tabulationNumber) {
    return '${''.padLeft(tabulationNumber, '\t')}$label';
  }

  void toDeepString([int tabulationNumber = 0]) {
    if (this is LeafSpecification<T>) {
      debugPrint(_tabulatedLabel('$this', tabulationNumber));
      return;
    }

    if (this is CompositeSpecification<T>) {
      final components = (this as CompositeSpecification<T>).components;
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
