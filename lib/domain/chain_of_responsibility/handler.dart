import 'package:dynamic_filter/domain/chain_of_responsibility/request.dart';
import 'package:dynamic_filter/domain/chain_of_responsibility/response.dart';

abstract interface class Handler<I extends Request, O extends Response> {
  Handler<I, O>? get next;
  O handle(I request);
}
