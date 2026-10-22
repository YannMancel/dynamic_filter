import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
final class OrCompositeFilter<T> extends CompositeFilter<T> {
  const OrCompositeFilter([super.components = const {}]);

  @override
  bool isSatisfiedBy(T object) {
    return components.any((component) => component.isSatisfiedBy(object));
  }

  @override
  Filter<T> withComponents(Set<Filter<T>> components) {
    return OrCompositeFilter(components);
  }

  @override
  String get componentSeparator => '||';
}
