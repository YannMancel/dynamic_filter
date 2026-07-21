import 'package:dynamic_filter/presentation/widgets/dynamic_filter_app.dart';
import 'package:dynamic_filter/service_locator/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  if (kDebugMode) setupDebugEvents();
  configureDependencies();
  runApp(const DynamicFilterApp());
}
