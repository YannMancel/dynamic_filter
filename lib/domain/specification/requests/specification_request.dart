import 'package:dynamic_filter/domain/chain_of_responsibility/request.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class SpecificationRequest<T> implements Request {
  const SpecificationRequest();

  const factory SpecificationRequest.delete(Specification<T> specification) =
      DeleteSpecificationRequest<T>;

  R when<R>({required R Function(Specification<T>) delete}) {
    return switch (this) {
      DeleteSpecificationRequest<T>(:final specification) => delete(
        specification,
      ),
    };
  }
}

@visibleForTesting
@immutable
final class DeleteSpecificationRequest<T> extends SpecificationRequest<T> {
  final Specification<T> specification;

  const DeleteSpecificationRequest(this.specification);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteSpecificationRequest &&
          runtimeType == other.runtimeType &&
          specification == other.specification;

  @override
  int get hashCode => specification.hashCode;
}
