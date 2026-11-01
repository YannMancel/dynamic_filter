import 'package:dynamic_filter/domain/chain_of_responsibility/response.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class FilterResponse<T> implements Response {
  const FilterResponse();

  R when<R>({
    required ValueGetter<R> empty,
    required R Function(Filter<T>) same,
    required R Function(Filter<T>) update,
  }) {
    return switch (this) {
      EmptyFilterResponse<T>() => empty(),
      SameFilterResponse<T>(:final filter) => same(filter),
      UpdateFilterResponse<T>(:final filter) => update(filter),
    };
  }
}

@immutable
final class SameFilterResponse<T> extends FilterResponse<T> {
  final Filter<T> filter;

  const SameFilterResponse(this.filter);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SameFilterResponse<T> &&
          runtimeType == other.runtimeType &&
          filter == other.filter;

  @override
  int get hashCode => filter.hashCode;
}

@immutable
final class EmptyFilterResponse<T> extends FilterResponse<T> {
  const EmptyFilterResponse();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmptyFilterResponse<T> && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

@immutable
final class UpdateFilterResponse<T> extends FilterResponse<T> {
  final Filter<T> filter;

  const UpdateFilterResponse(this.filter);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateFilterResponse<T> &&
          runtimeType == other.runtimeType &&
          filter == other.filter;

  @override
  int get hashCode => filter.hashCode;
}
