import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'routes/app_routes.dart';

void main() => runApp(const MyApp());

// Agar geser dan tarik-untuk-segarkan bisa dicoba dengan mouse di Chrome
class PerilakuScroll extends MaterialScrollBehavior {
  const PerilakuScroll();
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Kuliah',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const PerilakuScroll(),
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
