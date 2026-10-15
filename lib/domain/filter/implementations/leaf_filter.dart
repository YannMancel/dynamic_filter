import 'package:dynamic_filter/domain/filter/abstracts/abstract_filter.dart';
import 'package:dynamic_filter/domain/filter/filter_request.dart';
import 'package:dynamic_filter/domain/filter/filter_response.dart';

typedef Predicate<T> = bool Function(T);

final class LeafFilter<T> extends AbstractFilter<T> {
  final Predicate<T> _predicate;
  final String? _description;

  LeafFilter(this._predicate, {this._description});

  @override
  FilterResponse<T> handleDeleteRequest(DeleteFilterRequest<T> request) {
    // ┌ —————— ┬ —————————————— ┬ ——————————————————————————— ┐
    // |        | request.filter |                             |
    // | IsRoot ├ —————————————— ┤            Action           |
    // |        |     IsThis     |                             |
    // ├ —————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |   Yes  |       No       | UpdateFilterResponse + this |
    // ├ —————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |   Yes  |       Yes      |       NoFilterResponse      |
    // ├ —————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |   No   |       -        |        next + request       |
    // └ —————— ┴ —————————————— ┴ ——————————————————————————— ┘

    if (isRoot && this != request.filter) return UpdateFilterResponse(this);
    return next?.handle(request) ?? const NoFilterResponse();
  }

  @override
  bool isSatisfiedBy(T object) => _predicate(object);

  @override
  String toString() => _description ?? 'LeafFilter<$T>';
}
