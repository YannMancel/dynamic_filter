import 'package:dynamic_filter/domain/specification/abstracts/composite_specification.dart';

final class OrCompositeSpecification<T> extends CompositeSpecification<T> {
  const OrCompositeSpecification(super.components);

  @override
  bool isSatisfiedBy(T object) {
    return components.any((component) => component.isSatisfiedBy(object));
  }

  @override
  String get toStringComponentSeparator => '||';
}
