import 'package:dynamic_filter/domain/chain_of_responsibility/request.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class FilterRequest<T> implements Request {
  const FilterRequest();

  R map<R>({
    required R Function(DeleteFilterRequest<T>) delete,
    required R Function(RootFinderFilterRequest<T>) rootFinder,
  }) {
    return switch (this) {
      DeleteFilterRequest<T> r => delete(r),
      RootFinderFilterRequest<T> r => rootFinder(r),
    };
  }
}

@immutable
final class DeleteFilterRequest<T> extends FilterRequest<T> {
  final Filter<T> filter;

  const DeleteFilterRequest(this.filter);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteFilterRequest<T> &&
          runtimeType == other.runtimeType &&
          filter == other.filter;

  @override
  int get hashCode => filter.hashCode;
}

@immutable
final class RootFinderFilterRequest<T> extends FilterRequest<T> {
  const RootFinderFilterRequest();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RootFinderFilterRequest<T> && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
