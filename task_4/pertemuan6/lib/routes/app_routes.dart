import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../screens/detail_buku_page.dart';
import '../screens/home_page.dart';
import '../screens/konfirmasi_pinjam_page.dart';
import '../screens/login_page.dart';
import '../screens/tambah_buku_page.dart';
import '../screens/tentang_page.dart';
import '../screens/tidak_ditemukan_page.dart';

class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const detail = '/detail';
  static const tentang = '/tentang'; // Latihan 1
  static const konfirmasi = '/konfirmasi'; // Latihan 3
  static const tambah = '/tambah'; // Latihan 6

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: settings,
        );
      case home:
        final nama = switch (settings.arguments) {
          String s => s,
          _ => 'Tamu',
        };
        return MaterialPageRoute(
          builder: (context) => HomePage(nama: nama),
          settings: settings,
        );
      case detail:
        final args = settings.arguments;
        if (args is Buku) {
          // Latihan 7 (Tantangan): Efek memudar dengan PageRouteBuilder & FadeTransition
          return PageRouteBuilder<String>(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailBukuPage(buku: args),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return MaterialPageRoute(
          builder: (context) =>
              const TidakDitemukanPage(nama: 'argumen /detail salah'),
          settings: settings,
        );
      case tentang: // Latihan 1
        return MaterialPageRoute(
          builder: (context) => const TentangPage(),
          settings: settings,
        );
      case konfirmasi: // Latihan 3
        final args = settings.arguments;
        if (args is Buku) {
          return MaterialPageRoute<bool>(
            builder: (context) => KonfirmasiPinjamPage(buku: args),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (context) =>
              const TidakDitemukanPage(nama: 'argumen /konfirmasi salah'),
          settings: settings,
        );
      case tambah: // Latihan 6
        return MaterialPageRoute<Buku>(
          builder: (context) => const TambahBukuPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => TidakDitemukanPage(nama: settings.name),
          settings: settings,
        );
    }
  }
}