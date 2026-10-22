import 'package:dynamic_filter/domain/filter/abstracts/abstract_filter.dart';
import 'package:flutter/foundation.dart';

typedef Predicate<T> = bool Function(T);

@immutable
final class LeafFilter<T> extends AbstractFilter<T> {
  final Predicate<T> _predicate;
  final String? _description;

  const LeafFilter(this._predicate, {this._description});

  @override
  bool isSatisfiedBy(T object) => _predicate(object);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeafFilter<T> &&
          runtimeType == other.runtimeType &&
          _predicate == other._predicate &&
          _description == other._description;

  @override
  int get hashCode => Object.hash(super.hashCode, _predicate, _description);

  @override
  String toString() => _description ?? 'LeafFilter<$T>';
}
