import 'package:collection/collection.dart';
import 'package:dynamic_filter/domain/filter/abstracts/abstract_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CompositeFilter<T> extends AbstractFilter<T> {
  final Set<Filter<T>> _components;

  const CompositeFilter([this._components = const {}]);

  Filter<T> withComponents(Set<Filter<T>> components);

  String get componentSeparator;

  @override
  String toString() {
    final label = _components
        .map((component) => '$component')
        .join(' $componentSeparator ');
    return '($label)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositeFilter<T> &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(_components, other._components);

  @override
  int get hashCode => Object.hash(super.hashCode, _components);

  Set<Filter<T>> get components => Set.unmodifiable(_components);
}
