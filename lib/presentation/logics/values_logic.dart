import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:flutter/foundation.dart';

abstract interface class ValuesLogic {
  ValueNotifier<AsyncValue<Exception, List<int>>> get notifier;
  Future<void> initialize();
  Future<void> filter();
  void dispose();
}
