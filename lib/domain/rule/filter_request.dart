import 'package:dynamic_filter/domain/chain_of_responsibility/request.dart';
import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class FilterRequest<T> implements Request {
  const FilterRequest();

  R map<R>({
    required R Function(CompositeAddFilterRequest<T>) addToComposite,
    required R Function(DeleteFilterRequest<T>) delete,
    required R Function(PermuteFilterRequest<T>) permute,
  }) {
    return switch (this) {
      CompositeAddFilterRequest<T> r => addToComposite(r),
      DeleteFilterRequest<T> r => delete(r),
      PermuteFilterRequest<T> r => permute(r),
    };
  }
}

@immutable
final class CompositeAddFilterRequest<T> extends FilterRequest<T> {
  final CompositeFilter<T> from;
  final Filter<T> filter;

  const CompositeAddFilterRequest({required this.from, required this.filter});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositeAddFilterRequest<T> &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          filter == other.filter;

  @override
  int get hashCode => Object.hash(super.hashCode, from, filter);
}

@immutable
final class DeleteFilterRequest<T> extends FilterRequest<T> {
  final Filter<T> target;

  const DeleteFilterRequest(this.target);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteFilterRequest<T> &&
          runtimeType == other.runtimeType &&
          target == other.target;

  @override
  int get hashCode => Object.hash(super.hashCode, target);
}

@immutable
final class PermuteFilterRequest<T> extends FilterRequest<T> {
  final Filter<T> from;
  final Filter<T> to;

  const PermuteFilterRequest({required this.from, required this.to});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermuteFilterRequest<T> &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => Object.hash(super.hashCode, from, to);
}
