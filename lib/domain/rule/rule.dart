import 'package:dynamic_filter/domain/chain_of_responsibility/handler.dart';
import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/leaf_filter.dart';
import 'package:dynamic_filter/domain/rule/filter_request.dart';
import 'package:dynamic_filter/domain/rule/filter_response.dart';
import 'package:flutter/foundation.dart';

@immutable
final class Rule<T> implements Handler<FilterRequest<T>, FilterResponse<T>> {
  final Filter<T> _filter;
  final Rule<T>? _next;

  const Rule({required this._filter, this._next});

  @override
  Handler<FilterRequest<T>, FilterResponse<T>>? get next => _next;

  @override
  FilterResponse<T> handle(FilterRequest<T> request) {
    return request.map(
      addToComposite: _handleCompositeAddRequest,
      delete: _handleDeleteRequest,
      permute: _handlePermuteRequest,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rule<T> &&
          runtimeType == other.runtimeType &&
          _filter == other._filter &&
          _next == other._next;

  @override
  int get hashCode => Object.hash(_filter, _next);

  @override
  String toString() => 'Rule<$T>{filter: $_filter, next: $_next}';

  Filter<T> get filter => _filter;

  bool get isHead => _next == null;

  FilterResponse<T> _handleCompositeAddRequest(
    CompositeAddFilterRequest<T> request,
  ) {
    Filter<T> addFilter(CompositeFilter<T> composite) {
      return composite.withComponents({
        for (final component in composite.components)
          component == request.from
              ? (component as CompositeFilter<T>).withComponents({
                  ...component.components,
                  request.filter,
                })
              : component,
        if (filter == request.from) request.filter,
      });
    }

    // ┌ —————————————————————————————————————————————————————— ┐
    // |                   filter is LeafFilter                 |
    // ├ ——————— ┬ —————————————— ┬ ——————————————————————————— ┤
    // | is head | request.target |            return           |
    // |         |   is filter    |                             |
    // ├ ——————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |    ✓    |      ✓ / ✗     | SameFilterResponse + filter |
    // ├ ——————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |    ✗    |      ✓ / ✗     |        next + request       |
    // └ ——————— ┴ —————————————— ┴ ——————————————————————————— ┘

    if (filter is LeafFilter<T> && isHead) return SameFilterResponse<T>(filter);

    // ┌ ———————————————————————————————————————————————————————————————————— ┐
    // |                       filter is CompositeFilter                      |
    // ├ ——————— ┬ ———————————————————————————— ┬ ——————————————————————————— ┤
    // | is head |        request.target        |            return           |
    // |         | is filter | is in components |                             |
    // ├ ——————— ┼ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |           |                  |                             |
    // |         |     ✓     |       ✓ / ✗      |    UpdateFilterResponse +   |
    // |         |           |                  |          filter with        |
    // |    ✓    ├ ————————— ┼ ———————————————— ┤        request.filter       |
    // |         |     ✗     |         ✓        |                             |
    // |         ├ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |     ✗     |         ✗        |     SameFilterResponse +    |
    // |         |           |                  |           filter            |
    // ├ ——————— ┼ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |           |                  |                             |
    // |         |           |                  | next + PermuteFilterRequest |
    // |         |     ✗     |         ✓        |         from filter         |
    // |         |           |                  |        to filter with       |
    // |         |           |                  |        component with       |
    // |    ✗    ├ ————————— ┼ ———————————————— ┤        request.filter       |
    // |         |     ✓     |       ✓ / ✗      |                             |
    // |         ├ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |     ✗     |         ✗        |       next + request        |
    // └ ——————— ┴ ————— ——— ┴ ———————————————— ┴ ——————————————————————————— ┘

    if (filter case CompositeFilter<T> composite) {
      if (isHead) {
        if (filter == request.from ||
            composite.components.contains(request.from)) {
          return UpdateFilterResponse<T>(addFilter(composite));
        }
        return SameFilterResponse<T>(filter);
      }

      if (filter == request.from ||
          composite.components.contains(request.from)) {
        final permuteRequest = PermuteFilterRequest<T>(
          from: filter,
          to: addFilter(composite),
        );
        return next?.handle(permuteRequest) ?? EmptyFilterResponse<T>();
      }
    }

    return next?.handle(request) ?? EmptyFilterResponse<T>();
  }

  FilterResponse<T> _handleDeleteRequest(DeleteFilterRequest<T> request) {
    Filter<T> removeFilter(CompositeFilter<T> composite) {
      return composite.withComponents({
        for (final component in composite.components)
          if (component != request.target) component,
      });
    }

    // ┌ —————————————————————————————————————————————————————— ┐
    // |                   filter is LeafFilter                 |
    // ├ ——————— ┬ —————————————— ┬ ——————————————————————————— ┤
    // | is head | request.target |            return           |
    // |         |   is filter    |                             |
    // ├ ——————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |         |       ✗        | SameFilterResponse + filter |
    // |    ✓    ├ —————————————— ┼ ——————————————————————————— ┤
    // |         |       ✓        |     EmptyFilterResponse     |
    // ├ ——————— ┼ —————————————— ┼ ——————————————————————————— ┤
    // |    ✗    |     ✓ / ✗      |        next + request       |
    // └ ——————— ┴ —————————————— ┴ ——————————————————————————— ┘

    if (filter is LeafFilter<T> && isHead && filter != request.target) {
      return SameFilterResponse<T>(filter);
    }

    // ┌ ———————————————————————————————————————————————————————————————————— ┐
    // |                       filter is CompositeFilter                      |
    // ├ ——————— ┬ ———————————————————————————— ┬ ——————————————————————————— ┤
    // | is head |        request.target        |            return           |
    // |         | is filter | is in components |                             |
    // ├ ——————— ┼ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |     ✓     |       ✓ / ✗      |     EmptyFilterResponse     |
    // |         ├ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |           |         ✓        |    UpdateFilterResponse +   |
    // |    ✓    |           |                  |    filter without target    |
    // |         |     ✗     ├ ———————————————— ┼ ——————————————————————————— ┤
    // |         |           |         ✗        |     SameFilterResponse +    |
    // |         |           |                  |           filter            |
    // ├ ——————— ┼ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |           |                  | next + PermuteFilterRequest |
    // |         |     ✗     |         ✓        |         from filter         |
    // |         |           |                  |  to filter without target   |
    // |    ✗    ├ ————————— ┼ ———————————————— ┼ ——————————————————————————— ┤
    // |         |     ✓     |       ✓ / ✗      |                             |
    // |         ├ ————————— ┼ ———————————————— ┤       next + request        |
    // |         |     ✗     |         ✗        |                             |
    // └ ——————— ┴ ————— ——— ┴ ———————————————— ┴ ——————————————————————————— ┘

    if (filter case CompositeFilter<T> composite) {
      if (isHead) {
        if (filter == request.target) return EmptyFilterResponse<T>();
        if (composite.components.contains(request.target)) {
          return UpdateFilterResponse<T>(removeFilter(composite));
        }
        return SameFilterResponse<T>(filter);
      }

      if (filter != request.target &&
          composite.components.contains(request.target)) {
        final permuteRequest = PermuteFilterRequest<T>(
          from: filter,
          to: removeFilter(composite),
        );
        return next?.handle(permuteRequest) ?? EmptyFilterResponse<T>();
      }
    }

    return next?.handle(request) ?? EmptyFilterResponse<T>();
  }

  FilterResponse<T> _handlePermuteRequest(PermuteFilterRequest<T> request) {
    Filter<T> replaceFilter(CompositeFilter<T> composite) {
      return composite.withComponents({
        for (final component in composite.components)
          component == request.from ? request.to : component,
      });
    }

    // ┌ ———————————————————————————————————————————————————————————— ┐
    // |                      filter is LeafFilter                    |
    // ├ ——————— ┬ ———————————— ┬ ——————————————————————————————————— ┤
    // | is head | request.from |                return               |
    // |         |   is filter  |                                     |
    // ├ ——————— ┼ ———————————— ┼ ——————————————————————————————————— ┤
    // |         |       ✓      |  UpdateFilterResponse + request.to  |
    // |    ✓    ├ ———————————— ┼ ——————————————————————————————————— ┤
    // |         |       ✗      |     SameFilterResponse + filter     |
    // ├ ——————— ┼ ———————————— ┼ ——————————————————————————————————— ┤
    // |    ✗    |     ✓ / ✗    |            next + request           |
    // └ ——————— ┴ ———————————— ┴ ——————————————————————————————————— ┘

    if (filter is LeafFilter<T> && isHead) {
      return filter == request.from
          ? UpdateFilterResponse<T>(request.to)
          : SameFilterResponse<T>(filter);
    }

    // ┌ ————————————————————————————————————————————————————————————————————— ┐
    // |                        filter is CompositeFilter                      |
    // ├ ——————— ┬ ———————————————————————————— ┬ ———————————————————————————— ┤
    // | is head |         request.from         |            return            |
    // |         | is filter | is in components |                              |
    // ├ ——————— ┼ ————————— ┼ ———————————————— ┼ ———————————————————————————— ┤
    // |         |      ✓    |      ✓ / ✗       |    UpdateFilterResponse +    |
    // |         |           |                  |          request.to          |
    // |         ├ ————————— ┼ ———————————————— ┼ ———————————————————————————— ┤
    // |         |           |                  |    UpdateFilterResponse +    |
    // |         |           |        ✓         |           filter +           |
    // |    ✓    |           |                  |    replace request.from to   |
    // |         |      ✗    |                  |          request.to          |
    // |         |           ├ ———————————————— ┼ ———————————————————————————— ┤
    // |         |           |        ✗         |     SameFilterResponse +     |
    // |         |           |                  |            filter            |
    // ├ ——————— ┼ ————————— ┼ ———————————————— ┼ ———————————————————————————— ┤
    // |         |           |                  | next + PermuteFilterRequest  |
    // |         |      ✗    |        ✓         |    from filter to filter +   |
    // |         |           |                  |    replace request.from to   |
    // |         |           |                  |          request.to          |
    // |         ├ ————————— ┼ ———————————————— ┼ ———————————————————————————— ┤
    // |    ✗    |      ✓    |      ✓ / ✗       |                              |
    // |         ├ ————————— ┼ ———————————————— ┤         next + request       |
    // |         |      ✗    |        ✗         |                              |
    // └ ——————— ┴ ————————— ┴ ———————————————— ┴ ———————————————————————————— ┘

    if (filter case CompositeFilter<T> composite) {
      if (isHead) {
        if (filter == request.from) return UpdateFilterResponse<T>(request.to);
        if (composite.components.contains(request.from)) {
          return UpdateFilterResponse<T>(replaceFilter(composite));
        }
        return SameFilterResponse<T>(filter);
      }

      if (filter != request.from &&
          composite.components.contains(request.from)) {
        final permuteRequest = PermuteFilterRequest<T>(
          from: filter,
          to: replaceFilter(composite),
        );
        return next?.handle(permuteRequest) ?? const EmptyFilterResponse();
      }
    }

    return next?.handle(request) ?? const EmptyFilterResponse();
  }
}
