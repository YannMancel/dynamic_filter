import 'package:dynamic_filter/domain/specification/abstracts/abstract_specification.dart';
import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';

abstract class CompositeSpecification<T> extends AbstractSpecification<T> {
  late List<Specification<T>> _components;

  CompositeSpecification(List<Specification<T>> components) {
    for (final component in components) {
      component.successor = this;
    }
    _components = components;
  }

  @override
  void handle(SpecificationRequest<T> request) {
    request.when(
      delete: (specification) {
        if (!_components.contains(specification)) {
          successor?.handle(request);
          return;
        }
        _components = _components.where((e) => e != specification).toList();
      },
    );
  }

  List<Specification<T>> get components => List.unmodifiable(_components);

  void add(Specification<T> component) => _components.add(component);

  String get toStringComponentSeparator;

  @override
  String toString() {
    final label = components
        .map((component) => '$component')
        .join(' $toStringComponentSeparator ');
    return '($label)';
  }
}
