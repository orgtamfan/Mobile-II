import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../pages/form_page.dart';
import 'tugas_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Pesan background: ${message.messageId} ${message.data}');
}

class NotifikasiService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static const String topikPengumuman = 'pengumuman';
  static bool _sudahMulai = false;

  static Future<void> mulai() async {
    if (_sudahMulai) return;
    _sudahMulai = true;
    try {
      final izin = await _fcm.requestPermission();
      debugPrint('Izin notifikasi: ${izin.authorizationStatus}');
      FirebaseMessaging.onMessage.listen(_saatForeground);
      FirebaseMessaging.onMessageOpenedApp.listen(_bukaTugas);
      final pesanAwal = await _fcm.getInitialMessage();
      if (pesanAwal != null) _bukaTugas(pesanAwal);
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) _simpanToken(user);
      });
      _fcm.onTokenRefresh.listen((_) => _simpanToken());
    } catch (error) {
      debugPrint('Notifikasi tidak dapat dimulai: $error');
    }
  }

  static void _saatForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    final title = notification.title ?? 'Notifikasi';
    final body = notification.body ?? '';
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('$title: $body'),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'BUKA',
          onPressed: () => _bukaTugas(message),
        ),
      ),
    );
  }

  static Future<void> _bukaTugas(RemoteMessage message) async {
    final id = message.data['tugasId'] as String?;
    if (id == null || id.isEmpty) return;
    final user = await FirebaseAuth.instance.authStateChanges().first;
    if (user == null) return;
    try {
      final tugas = await TugasService().ambil(id);
      final navigator = navigatorKey.currentState;
      if (tugas != null && navigator != null) {
        navigator.push(
          MaterialPageRoute<void>(builder: (_) => FormPage(tugas: tugas)),
        );
      }
    } catch (error) {
      debugPrint('Gagal membuka tugas dari notifikasi: $error');
    }
  }

  static Future<void> _simpanToken([User? signedInUser]) async {
    final user = signedInUser ?? FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final profilRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final profil = await profilRef.get();
      final notifikasiAktif =
          (profil.data()?['notifikasiAktif'] as bool?) ?? true;
      await profilRef.set({
        'notifikasiAktif': notifikasiAktif,
      }, SetOptions(merge: true));

      final token = await _fcm.getToken();
      if (token == null) return;
      debugPrint('FCM token: $token');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tokens')
          .doc(token)
          .set({
            'token': token,
            'platform': defaultTargetPlatform.name,
            'diperbarui': FieldValue.serverTimestamp(),
          });
      if (notifikasiAktif) {
        await _fcm.subscribeToTopic(topikPengumuman);
      } else {
        await _fcm.unsubscribeFromTopic(topikPengumuman);
      }
    } catch (error) {
      debugPrint('Gagal menyimpan token: $error');
    }
  }

  static Future<bool> ambilPreferensiNotifikasi() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return (doc.data()?['notifikasiAktif'] as bool?) ?? true;
  }

  static Future<void> aturNotifikasiAktif(bool aktif) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final profilRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    await profilRef.set({'notifikasiAktif': aktif}, SetOptions(merge: true));
    try {
      if (aktif) {
        await _fcm.subscribeToTopic(topikPengumuman);
      } else {
        await _fcm.unsubscribeFromTopic(topikPengumuman);
      }
    } catch (_) {
      await profilRef.set({'notifikasiAktif': !aktif}, SetOptions(merge: true));
      rethrow;
    }
  }

  static Future<void> hapusToken() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final token = await _fcm.getToken();
      if (user != null && token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tokens')
            .doc(token)
            .delete();
      }
      await _fcm.unsubscribeFromTopic(topikPengumuman);
    } catch (error) {
      debugPrint('Gagal menghapus token: $error');
    }
  }

  static Future<String?> ambilToken() async {
    try {
      return await _fcm.getToken();
    } catch (error) {
      debugPrint('Gagal mengambil token: $error');
      return null;
    }
  }
}
