import 'package:dynamic_filter/domain/specification/abstracts/composite_specification.dart';

final class AndCompositeSpecification<T> extends CompositeSpecification<T> {
  const AndCompositeSpecification(super.components);

  @override
  bool isSatisfiedBy(T object) {
    return components.every((component) => component.isSatisfiedBy(object));
  }

  @override
  String get toStringComponentSeparator => '&&';
}
