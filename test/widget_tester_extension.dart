import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTestExt on WidgetTester {
  Future<void> _setupBinding(Size size) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(size);
    view
      ..physicalSize = size
      ..devicePixelRatio = 1;

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });
  }

  Future<void> pumpCustomWidget(
    Widget widget, {
    Size size = const Size(720, 1280),
  }) async {
    await _setupBinding(size);
    await pumpWidget(widget);
  }
}
