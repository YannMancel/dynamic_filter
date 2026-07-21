import 'package:dynamic_filter/domain/specification/impl/and_composite_specification.dart';
import 'package:dynamic_filter/domain/specification/impl/or_composite_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';

abstract class AbstractSpecification<T> implements Specification<T> {
  const AbstractSpecification({this._description});

  final String? _description;
  String? get description => _description;

  @override
  Specification<T> and(Specification<T> specification) {
    return AndCompositeSpecification([this, specification]);
  }

  @override
  Specification<T> or(Specification<T> specification) {
    return OrCompositeSpecification([this, specification]);
  }
}
