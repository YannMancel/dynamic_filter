import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/and_composite_filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/or_composite_filter.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AbstractFilter<T> implements Filter<T> {
  const AbstractFilter();

  @override
  Filter<T> and(covariant Filter<T> filter) {
    if (this case AndCompositeFilter<T> composite) {
      return composite.withComponents({...composite.components, filter});
    }
    return AndCompositeFilter<T>({this, filter});
  }

  @override
  Filter<T> or(covariant Filter<T> filter) {
    if (this case OrCompositeFilter<T> composite) {
      return composite.withComponents({...composite.components, filter});
    }
    return OrCompositeFilter<T>({this, filter});
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbstractFilter<T> && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
