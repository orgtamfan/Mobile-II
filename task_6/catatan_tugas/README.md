# Catatan Tugas

Aplikasi praktikum Mobile II berbasis Flutter dan Firebase. Fitur yang disiapkan:

- Registrasi, login, dan logout dengan Firebase Authentication.
- CRUD tugas per pengguna menggunakan Cloud Firestore.
- Foto tugas yang dikecilkan lalu disimpan sebagai Base64 pada field `lampiranBase64`.
- Notifikasi Firebase Cloud Messaging untuk foreground, background, dan terminated, beserta token per pengguna dan topik `pengumuman`.

## Menjalankan di Android

1. Pastikan Firebase Authentication (Email/Password), Cloud Firestore, dan Cloud Messaging aktif pada proyek Firebase yang dikonfigurasi.
2. Publikasikan isi [`firestore.rules`](firestore.rules) pada Firebase Console > Firestore Database > Rules.
3. Ambil dependency dan jalankan aplikasi:

   ```sh
   flutter pub get
   flutter run
   ```

Untuk memublikasikan Rules melalui Firebase CLI, jalankan `firebase login`, lalu `firebase deploy --only firestore:rules --project olan-ajah` dari folder proyek ini. `firebase.json` sudah menunjuk ke `firestore.rules`.

Gunakan emulator atau perangkat Android dengan Google Play Services untuk menerima FCM. Android 13 ke atas meminta izin notifikasi saat aplikasi dibuka.

Pada halaman utama, ikon lonceng menampilkan token FCM untuk pengujian pesan dari Firebase Console. Pesan topik menggunakan nama `pengumuman`; untuk membuka tugas tertentu, sertakan pasangan data `tugasId` yang berisi ID dokumen tugas milik akun yang sedang login.

## Pemeriksaan modul

Modul mencakup 21 skenario pengujian dan empat latihan mandiri. Daftar skenario serta bukti yang perlu direkam ada di Bab 8.1 dan 9.2 PDF modul. Pastikan mencatat hasil langsung pada emulator/perangkat dan Firebase Console; status tersebut tidak dapat disimpulkan dari source code saja.

Latihan mandiri Bab 9 yang tersedia:

- Foto pada kartu dapat dibuka layar penuh, diperbesar, dan memakai transisi Hero.
- Langganan topik `pengumuman` dapat diatur per pengguna.
- Foto profil Base64 dapat diubah dari halaman Pengaturan dan tampil pada sapaan HomePage.
- Form tugas menampilkan ukuran foto dan peringatan saat melewati 150 KB.
