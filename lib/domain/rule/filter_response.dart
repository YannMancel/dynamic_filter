import 'package:dynamic_filter/domain/chain_of_responsibility/response.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class FilterResponse<T> implements Response {
  const FilterResponse();

  R when<R>({
    required ValueGetter<R> noFilter,
    required R Function(Filter<T>) update,
  }) {
    return switch (this) {
      NoFilterResponse<T>() => noFilter(),
      UpdateFilterResponse<T>(:final filter) => update(filter),
    };
  }
}

@immutable
final class NoFilterResponse<T> extends FilterResponse<T> {
  const NoFilterResponse();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoFilterResponse<T> && runtimeType == other.runtimeType;

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
