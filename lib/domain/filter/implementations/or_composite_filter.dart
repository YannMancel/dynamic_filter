import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';

final class OrCompositeFilter<T> extends CompositeFilter<T> {
  OrCompositeFilter([super.components = const []]);

  @override
  bool isSatisfiedBy(T object) {
    return components.any((component) => component.isSatisfiedBy(object));
  }

  @override
  String get componentSeparator => '||';
}
