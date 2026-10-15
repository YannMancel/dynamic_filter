import 'package:dynamic_filter/domain/chain_of_responsibility/handler.dart';
import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/filter_request.dart';
import 'package:dynamic_filter/domain/filter/filter_response.dart';
import 'package:dynamic_filter/domain/filter/implementations/and_composite_filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/or_composite_filter.dart';

abstract class AbstractFilter<T> implements Filter<T> {
  late Handler<FilterRequest<T>, FilterResponse<T>>? _next;

  AbstractFilter() : _next = null;

  FilterResponse<T> handleDeleteRequest(DeleteFilterRequest<T> request);

  @override
  Handler<FilterRequest<T>, FilterResponse<T>>? get next => _next;

  @override
  set next(Handler<FilterRequest<T>, FilterResponse<T>>? next) => _next = next;

  @override
  FilterResponse<T> handle(FilterRequest<T> request) {
    return request.map(
      delete: handleDeleteRequest,
      rootFinder: _handleRootFinderRequest,
    );
  }

  @override
  Filter<T> and(Filter<T> filter) {
    if (isAndComposite) {
      (this as CompositeFilter<T>).addComponent(filter);
      return this;
    }
    return AndCompositeFilter<T>([this, filter]);
  }

  @override
  Filter<T> or(Filter<T> filter) {
    if (isOrComposite) {
      (this as CompositeFilter<T>).addComponent(filter);
      return this;
    }
    return OrCompositeFilter<T>([this, filter]);
  }

  @override
  bool get isRoot => _next == null;

  @override
  bool get isComposite => this is CompositeFilter<T>;

  @override
  bool get isAndComposite => this is AndCompositeFilter<T>;

  @override
  bool get isOrComposite => this is OrCompositeFilter<T>;

  FilterResponse<T> _handleRootFinderRequest(
    RootFinderFilterRequest<T> request,
  ) {
    // ┌ —————— ┬ ——————————————————————————— ┐
    // |        |                             |
    // | IsRoot ├            Action           |
    // |        |                             |
    // ├ —————— ┼ ——————————————————————————— ┤
    // |   Yes  | UpdateFilterResponse + this |
    // ├ —————— ┼ ——————————————————————————— ┤
    // |   No   |        next + request       |
    // └ —————— ┴ ——————————————————————————— ┘
    return next?.handle(request) ?? UpdateFilterResponse(this);
  }
}
