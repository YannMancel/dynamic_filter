import 'package:dynamic_filter/domain/chain_of_responsibility/handler.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
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
    // TODO: implement handle
    throw UnimplementedError();
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
  String toString() {
    return 'Rule<$T>{filter: $_filter, next: $_next}';
  }

  Filter<T> get filter => _filter;
}
