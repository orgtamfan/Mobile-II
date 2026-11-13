import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'services/fcm_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/notifikasi/daftar_notifikasi_screen.dart';
import 'widgets/loading_indicator.dart';

final FcmService _fcmService = FcmService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handler notifikasi background (F-FCM-03) - harus didaftarkan sebelum runApp.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Format tanggal Bahasa Indonesia untuk intl.
  await initializeDateFormatting('id_ID', null);

  runApp(const AutoLogApp());
}

class AutoLogApp extends StatelessWidget {
  const AutoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoLog',
      debugShowCheckedModeBanner: false,
      navigatorKey: FcmService.navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A5F), // biru otomotif
          primary: const Color(0xFF1E3A5F),
          secondary: const Color(0xFF64748B), // abu
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A5F),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      // F-AUTH-06 & F-AUTH-07: Session persistence & proteksi halaman.
      // authStateChanges() secara otomatis memantau status login,
      // termasuk saat aplikasi ditutup & dibuka kembali.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: LoadingIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }

          _fcmService.init(user.uid);
          return const HomeScreen();
        },
      ),
      routes: {
        '/notifikasi': (context) => const DaftarNotifikasiScreen(),
      },
    );
  }
}
