import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../models/notifikasi_model.dart';
import 'firestore_service.dart';

/// Handler notifikasi background. HARUS berupa top-level function
/// (bukan method di dalam class) sesuai ketentuan firebase_messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Notifikasi diterima di background: ${message.messageId}');
}

/// Service untuk Firebase Cloud Messaging.
/// Menangani izin notifikasi, FCM token, handler foreground/background,
/// tampilan in-app, dan navigasi saat notifikasi diketuk.
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// Navigator key global agar FCM bisa navigasi tanpa BuildContext.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Inisialisasi: minta izin, setup local notifications, ambil token,
  /// dan pasang semua listener. Dipanggil sekali setelah user login.
  Future<void> init(String uid) async {
    await _mintaIzin();
    await _setupLocalNotifications();
    await _ambilDanSimpanToken(uid);

    // F-FCM-03: Notifikasi diterima saat app foreground.
    FirebaseMessaging.onMessage.listen((message) {
      _simpanNotifikasiKeFirestore(uid, message);
      _tampilkanDialogForeground(message);
    });

    // F-FCM-05: Tap notifikasi saat app di background (bukan terminated).
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _simpanNotifikasiKeFirestore(uid, message);
      _navigasiKeRiwayatServis();
    });

    // App dibuka dari kondisi terminated via tap notifikasi.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _simpanNotifikasiKeFirestore(uid, initialMessage);
      _navigasiKeRiwayatServis();
    }

    // Token bisa berubah (reinstall, dsb) - simpan ulang jika refresh.
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _firestoreService.simpanFcmToken(uid, newToken);
    });
  }

  /// F-FCM-01: Minta izin notifikasi saat pertama buka.
  Future<void> _mintaIzin() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _navigasiKeRiwayatServis();
      },
    );

    const channel = AndroidNotificationChannel(
      'autolog_channel',
      'AutoLog Notifikasi',
      description: 'Notifikasi pengingat & info servis kendaraan',
      importance: Importance.high,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// F-FCM-02: Ambil token FCM & simpan ke Firestore agar tampil di profil.
  Future<void> _ambilDanSimpanToken(String uid) async {
    try {
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        await _firestoreService.simpanFcmToken(uid, _fcmToken!);
      }
    } catch (e) {
      developer.log('Gagal mengambil FCM token: $e');
    }
  }

  void _simpanNotifikasiKeFirestore(String uid, RemoteMessage message) {
    final judul = message.notification?.title ?? 'Notifikasi AutoLog';
    final pesan = message.notification?.body ?? '';
    _firestoreService.simpanNotifikasi(
      uid,
      NotifikasiModel(
        id: '',
        judul: judul,
        pesan: pesan,
        tanggal: DateTime.now(),
        sudahDibaca: false,
      ),
    );
  }

  /// F-FCM-04: Tampilan in-app berupa dialog saat app foreground.
  void _tampilkanDialogForeground(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final judul = message.notification?.title ?? 'Notifikasi AutoLog';
    final pesan = message.notification?.body ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(judul),
        content: Text(pesan),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _navigasiKeRiwayatServis();
            },
            child: const Text('Lihat'),
          ),
        ],
      ),
    );
  }

  /// F-FCM-05: Navigasi ke halaman Daftar Notifikasi saat notifikasi diketuk.
  void _navigasiKeRiwayatServis() {
    navigatorKey.currentState?.pushNamed('/notifikasi');
  }
}
