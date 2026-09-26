import 'package:dynamic_filter/domain/specification/abstracts/abstract_specification.dart';
import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';

typedef Predicate<T> = bool Function(T);

final class LeafSpecification<T> extends AbstractSpecification<T> {
  final Predicate<T> _predicate;

  LeafSpecification(this._predicate, {super.description});

  @override
  void handle(SpecificationRequest<T> request) {
    request.when(delete: (_) => successor?.handle(request));
  }

  @override
  bool isSatisfiedBy(T object) => _predicate(object);

  @override
  String toString() {
    return description ?? 'LeafSpecification{predicate: $_predicate}';
  }
}
