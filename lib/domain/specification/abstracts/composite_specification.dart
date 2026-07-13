import 'package:dynamic_filter/domain/specification/abstracts/abstract_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';

abstract class CompositeSpecification<T> extends AbstractSpecification<T> {
  const CompositeSpecification(this._components);

  final List<Specification<T>> _components;

  List<Specification<T>> get components => _components;

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
