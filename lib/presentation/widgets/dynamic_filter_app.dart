import 'package:dynamic_filter/presentation/widgets/values_page.dart';
import 'package:flutter/material.dart';

const appName = 'Dynamic filter';

class DynamicFilterApp extends StatelessWidget {
  const DynamicFilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple))
          .copyWith(
            listTileTheme: const ListTileThemeData(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.deepPurpleAccent),
                borderRadius: .all(.circular(16)),
              ),
            ),
          ),
      home: const ValuesPage(title: appName),
    );
  }
}
