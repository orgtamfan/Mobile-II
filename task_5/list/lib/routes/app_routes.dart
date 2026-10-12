import 'package:flutter/material.dart';
import '../models/tugas.dart';
import '../screens/daftar_tugas_page.dart';
import '../screens/form_tugas_page.dart';

class AppRoutes {
  static const home = '/';
  static const form = '/form';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const DaftarTugasPage(),
          settings: settings,
        );
      case form:
        final tugas = settings.arguments as Tugas?;
        // Latihan 7: Animasi FadeTransition menggunakan PageRouteBuilder
        return PageRouteBuilder<Tugas>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              FormTugasPage(tugas: tugas),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Tidak Ditemukan')),
            body: Center(child: Text('Rute ${settings.name} tidak ditemukan')),
          ),
          settings: settings,
        );
    }
  }
}
