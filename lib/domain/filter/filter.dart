import 'package:dynamic_filter/domain/chain_of_responsibility/handler.dart';
import 'package:dynamic_filter/domain/filter/filter_request.dart';
import 'package:dynamic_filter/domain/filter/filter_response.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';

abstract interface class Filter<T>
    implements
        Specification<Filter<T>, T>,
        Handler<FilterRequest<T>, FilterResponse<T>> {
  bool get isRoot;
  bool get isComposite;
  bool get isAndComposite;
  bool get isOrComposite;
}
