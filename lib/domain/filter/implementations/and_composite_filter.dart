import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
final class AndCompositeFilter<T> extends CompositeFilter<T> {
  const AndCompositeFilter([super.components = const {}]);

  @override
  bool isSatisfiedBy(T object) {
    return components.every((component) => component.isSatisfiedBy(object));
  }

  @override
  Filter<T> withComponents(Set<Filter<T>> components) {
    return AndCompositeFilter(components);
  }

  @override
  String get componentSeparator => '&&';
}
