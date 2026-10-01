import 'package:dynamic_filter/domain/chain_of_responsibility/handler.dart';
import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';

abstract interface class Specification<T>
    implements Handler<SpecificationRequest<T>> {
  bool isSatisfiedBy(T object);
  Specification<T> and(Specification<T> specification);
  Specification<T> or(Specification<T> specification);
  bool get isRoot;
  bool get isComposite;
  bool get isAndComposite;
  bool get isOrComposite;
}
