// File ini SEHARUSNYA digenerate otomatis oleh FlutterFire CLI, BUKAN ditulis manual.
//
// Cara generate yang benar:
//   1. dart pub global activate flutterfire_cli
//   2. flutterfire configure
//   3. Pilih / buat project Firebase Anda, lalu pilih platform Android.
//
// Perintah di atas akan MENIMPA file ini secara otomatis dengan nilai asli
// dari project Firebase Anda (apiKey, appId, projectId, dll), dan juga akan
// membuat file android/app/google-services.json.
//
// Nilai di bawah ini hanyalah PLACEHOLDER agar project bisa di-build sebelum
// dikonfigurasi. Aplikasi TIDAK akan bisa terhubung ke Firebase sampai Anda
// menjalankan `flutterfire configure`.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'AutoLog dikonfigurasi untuk Android. Jalankan flutterfire configure untuk menambah platform lain.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions belum dikonfigurasi untuk platform ini. '
          'Jalankan flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'GANTI_DENGAN_API_KEY_ANDA',
    appId: 'GANTI_DENGAN_APP_ID_ANDA',
    messagingSenderId: 'GANTI_DENGAN_SENDER_ID_ANDA',
    projectId: 'GANTI_DENGAN_PROJECT_ID_ANDA',
    storageBucket: 'GANTI_DENGAN_PROJECT_ID_ANDA.appspot.com',
  );
}
