import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:flutter/foundation.dart';

abstract interface class FilterLogic {
  ValueNotifier<Specification<int>?> get notifier;
  void update();
  void dispose();
}
