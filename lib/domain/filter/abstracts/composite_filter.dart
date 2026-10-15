import 'package:dynamic_filter/domain/filter/abstracts/abstract_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/filter_request.dart';
import 'package:dynamic_filter/domain/filter/filter_response.dart';

abstract class CompositeFilter<T> extends AbstractFilter<T> {
  late List<Filter<T>> _components;

  CompositeFilter([List<Filter<T>> components = const []]) {
    for (final component in components) {
      component.next = this;
    }
    _components = components;
  }

  String get componentSeparator;

  @override
  FilterResponse<T> handleDeleteRequest(DeleteFilterRequest<T> request) {
    // ┌ —————— ┬ —————————————————————— ┬ ————————————————————————————————————————————————— ┐
    // |        |     request.filter     |                                                   |
    // | IsRoot ├ —————— ┬ ————————————— ┤                   Action                          |
    // |        | IsThis | IsInComponent |                                                   |
    // ├ —————— ┼ —————— ┼ ————————————— ┼ ————————————————————————————————————————————————— ┤
    // |   Yes  |   Yes  |      -        |               NoFilterResponse                    |
    // ├ —————— ┼ —————— ┼ ————————————— ┼ ————————————————————————————————————————————————— ┤
    // |   Yes  |   No   |      Yes      | delete component + UpdateFilterResponse + this    |
    // ├ —————— ┼ —————— ┼ ————————————— ┼ ————————————————————————————————————————————————— ┤
    // |   Yes  |   No   |      No       |        UpdateFilterResponse + this                |
    // ├ —————— ┼ —————— ┼ ————————————— ┼ ————————————————————————————————————————————————— ┤
    // |   No   |   Yes  |      -        |                next + request                     |
    // ├ —————— ┼ —————— ┼ ————————————— ┼ ————————————————————————————————————————————————— ┤
    // |   No   |   No   |      No       |                next + request                     |
    // ├ —————— ┼ —————— ┼ ————————————— ┼ ————————————————————————————————————————————————— ┤
    // |   No   |   No   |      Yes      | delete component + next + RootFinderFilterRequest |
    // └ —————— ┴ —————— ┴ ————————————— ┴ ————————————————————————————————————————————————— ┘

    if (isRoot) {
      if (this == request.filter) return const NoFilterResponse();
      if (components.contains(request.filter)) {
        _components = _deleteFilterIntoComponents(request.filter);
      }
      return UpdateFilterResponse(this);
    }

    if (this != request.filter && _components.contains(request.filter)) {
      _components = _deleteFilterIntoComponents(request.filter);
      return next!.handle(const RootFinderFilterRequest());
    }

    return next!.handle(request);
  }

  @override
  String toString() {
    final label = _components
        .map((component) => '$component')
        .join(' $componentSeparator ');
    return '($label)';
  }

  List<Filter<T>> get components => List.unmodifiable(_components);

  set components(List<Filter<T>> components) => _components = components;

  void addComponent(Filter<T> filter) {
    filter.next = this;
    _components.add(filter);
  }

  List<Filter<T>> _deleteFilterIntoComponents(Filter<T> filter) {
    return [
      for (final component in _components)
        if (component != filter) component,
    ];
  }
}
