import 'package:dynamic_filter/domain/specification/abstracts/abstract_specification.dart';

typedef Predicate<T> = bool Function(T);

final class LeafSpecification<T> extends AbstractSpecification<T> {
  const LeafSpecification(this._predicate, {super.description});

  final Predicate<T> _predicate;

  @override
  bool isSatisfiedBy(T object) => _predicate(object);

  @override
  String toString() {
    return description ?? 'LeafSpecification{predicate: $_predicate}';
  }
}
