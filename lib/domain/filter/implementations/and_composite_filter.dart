import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';

final class AndCompositeFilter<T> extends CompositeFilter<T> {
  AndCompositeFilter([super.components = const []]);

  @override
  bool isSatisfiedBy(T object) {
    return components.every((component) => component.isSatisfiedBy(object));
  }

  @override
  String get componentSeparator => '&&';
}
