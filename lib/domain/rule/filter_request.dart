import 'package:dynamic_filter/domain/chain_of_responsibility/request.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class FilterRequest<T> implements Request {
  const FilterRequest();

  R map<R>({
    required R Function(DeleteFilterRequest<T>) delete,
    required R Function(PermuteFilterRequest<T>) permute,
  }) {
    return switch (this) {
      DeleteFilterRequest<T> r => delete(r),
      PermuteFilterRequest<T> r => permute(r),
    };
  }
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
  int get hashCode => target.hashCode;
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
  int get hashCode => Object.hash(from, to);
}
