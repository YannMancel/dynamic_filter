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

  String get toStringComponentSeparator;

  @override
  String toString() {
    final buffer = StringBuffer();
    for (int i = 0; i < components.length; i++) {
      if (i == 0) buffer.write('(');
      buffer.write('${components[i]}');
      if (i < components.length - 1) {
        buffer.write(' $toStringComponentSeparator ');
        continue;
      }
      if (i == components.length - 1) buffer.write(')');
    }
    return buffer.toString();
  }
}
