import 'package:dynamic_filter/domain/specification/impl/leaf_specification.dart';

final equalTo5 = LeafSpecification<int>((e) => e == 5, description: 'x == 5');
final higherThan6 = LeafSpecification<int>((e) => e > 6, description: 'x > 6');
final lowerThan10 = LeafSpecification<int>(
  (e) => e < 10,
  description: 'x < 10',
);

final itemsFrom1To10 = List<int>.unmodifiable(
  List.generate(10, (index) => index + 1),
);
