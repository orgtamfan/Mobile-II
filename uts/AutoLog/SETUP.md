# AutoLog — Panduan Setup

Kode di repo ini adalah isi folder `lib/` + file pendukung sesuai PRD. Karena
`flutter create` butuh Flutter SDK terpasang (tidak tersedia di lingkungan ini),
ikuti langkah berikut di komputer Anda untuk menjalankannya.

## 1. Buat skeleton project Flutter

```bash
flutter create autolog
```

Lalu salin isi folder `lib/` dari paket ini ke dalam `autolog/lib/` (timpa
`main.dart` bawaan), dan salin `pubspec.yaml` (timpa yang bawaan juga, lalu
samakan nama `name:` jika perlu).

## 2. Install dependencies

```bash
cd autolog
flutter pub get
```

## 3. Hubungkan ke Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Pilih atau buat project Firebase Anda, pilih platform **Android**. Perintah
ini akan:
- Menimpa `lib/firebase_options.dart` dengan nilai asli project Anda.
- Membuat `android/app/google-services.json` otomatis.

## 4. Aktifkan layanan Firebase di Console

- **Authentication** → Sign-in method → aktifkan **Email/Password**.
- **Firestore Database** → buat database, lalu tempel isi `firestore.rules`
  (di root paket ini) ke tab Rules.
- **Storage** → aktifkan, lalu tempel isi `storage.rules` ke tab Rules.
- **Cloud Messaging** → tidak perlu konfigurasi tambahan untuk uji kirim dari
  Console (Messaging → New campaign → masukkan FCM token dari halaman Profil).

## 5. Tambahkan permission Android

Buka `android/app/src/main/AndroidManifest.xml` project hasil `flutter create`,
lalu tambahkan isi dari `android/app/src/main/AndroidManifestAdditions.xml`
(paket ini) ke posisi yang sesuai (lihat komentar di dalam file tersebut).

Pastikan juga `android/app/build.gradle` punya:
```gradle
minSdkVersion 23  // minimal untuk Firebase Auth & Messaging terbaru
```

## 6. Jalankan aplikasi

```bash
flutter run
```

Gunakan emulator dengan **Google Play Services** (atau perangkat fisik) agar
Firebase Cloud Messaging berfungsi — emulator tanpa Play Services tidak bisa
menerima notifikasi (lihat Risiko & Mitigasi di PRD).

## 7. Uji skenario sesuai PRD (bagian 12)

- Register → login → tutup & buka app (sesi tetap tersimpan)
- Tambah kendaraan → tambah servis + foto nota (lihat progress upload)
- Buka detail servis → hapus foto/servis → cek hilang dari Storage Console
- Kirim notifikasi dari Firebase Console → Messaging → New campaign, tempel
  FCM token dari halaman Profil sebagai target, uji saat app foreground &
  background, lalu tap notifikasi untuk cek navigasi ke halaman Notifikasi.

## Struktur yang sudah dibuat

```
lib/
├── main.dart
├── firebase_options.dart        (placeholder — akan ditimpa flutterfire configure)
├── models/
│   ├── kendaraan_model.dart
│   ├── servis_model.dart
│   └── notifikasi_model.dart
├── services/
│   ├── auth_service.dart
│   ├── storage_service.dart
│   ├── firestore_service.dart
│   └── fcm_service.dart
├── screens/
│   ├── auth/{login_screen,register_screen}.dart
│   ├── home/home_screen.dart
│   ├── kendaraan/{daftar_kendaraan_screen,tambah_kendaraan_screen}.dart
│   ├── servis/{riwayat_servis_screen,tambah_servis_screen,detail_servis_screen}.dart
│   ├── notifikasi/daftar_notifikasi_screen.dart
│   └── profil/profil_screen.dart
└── widgets/
    ├── custom_button.dart
    ├── loading_indicator.dart
    └── servis_card.dart
```

Semua nama fitur dipetakan ke ID requirement PRD lewat komentar di kode
(contoh: `// F-STR-02: Indikator Upload`), memudahkan pengecekan saat
penyusunan laporan.
