import 'package:dynamic_filter/domain/chain_of_responsibility/request.dart';

abstract interface class Handler<R extends Request> {
  Handler<R>? get successor;
  set successor(Handler<R>? successor);
  void handle(R request);
}
