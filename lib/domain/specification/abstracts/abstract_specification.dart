import 'package:dynamic_filter/domain/chain_of_responsibility/handler.dart';
import 'package:dynamic_filter/domain/specification/abstracts/composite_specification.dart';
import 'package:dynamic_filter/domain/specification/impl/and_composite_specification.dart';
import 'package:dynamic_filter/domain/specification/impl/or_composite_specification.dart';
import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';

abstract class AbstractSpecification<T> implements Specification<T> {
  Handler<SpecificationRequest<T>>? _successor;
  final String? _description;

  AbstractSpecification({this._successor, this._description});

  @override
  Handler<SpecificationRequest<T>>? get successor => _successor;

  @override
  set successor(Handler<SpecificationRequest<T>>? successor) {
    _successor = successor;
  }

  @override
  Specification<T> and(Specification<T> specification) {
    if (this is AndCompositeSpecification<T>) {
      (this as CompositeSpecification<T>).add(specification);
      return this;
    }
    return AndCompositeSpecification([this, specification]);
  }

  @override
  Specification<T> or(Specification<T> specification) {
    if (this is OrCompositeSpecification<T>) {
      (this as CompositeSpecification<T>).add(specification);
      return this;
    }
    return OrCompositeSpecification([this, specification]);
  }

  @override
  bool get isRoot => _successor == null;

  @override
  bool get isComposite => this is CompositeSpecification<T>;

  @override
  bool get isAndComposite => this is AndCompositeSpecification<T>;

  @override
  bool get isOrComposite => this is OrCompositeSpecification<T>;

  String? get description => _description;
}
