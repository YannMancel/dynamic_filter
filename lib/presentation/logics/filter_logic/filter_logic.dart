import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:flutter/foundation.dart';

abstract interface class FilterLogic {
  ValueNotifier<Specification<int>?> get notifier;
  void filterByDefault();
  void delete(Specification<int> specification);
  void reset();
  void dispose();
}
