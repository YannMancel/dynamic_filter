import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:flutter/foundation.dart';

abstract interface class FilterLogic {
  ValueNotifier<Filter<int>?> get notifier;
  void filterByDefault();
  void delete(Filter<int> filter);
  void reset();
  void dispose();
}
