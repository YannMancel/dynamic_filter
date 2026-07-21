import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/impl/filter_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/filtered_values_logic.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/impl/filtered_values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/impl/values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDebugEvents() {
  getIt.debugEventsEnabled = true;
}

void configureDependencies() {
  getIt.registerFactory<ValuesLogic>(ValuesLogicImpl.new);
  getIt.registerFactory<FilterLogic>(FilterLogicImpl.new);
  getIt.registerFactoryParam<
    FilteredValuesLogic,
    ValueNotifier<AsyncValue<Exception, List<int>>>,
    ValueNotifier<Specification<int>?>
  >(FilteredValuesLogicImpl.new);
}
