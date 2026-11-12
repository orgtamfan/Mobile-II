import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get penggunaSaatIni => _auth.currentUser;

  Stream<User?> get perubahanPengguna => _auth.userChanges();

  Future<void> masuk(String email, String sandi) {
    return _auth.signInWithEmailAndPassword(email: email, password: sandi);
  }

  Future<void> daftar(String nama, String email, String sandi) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: sandi,
    );
    await cred.user?.updateDisplayName(nama);
    await cred.user?.reload();
  }

  Future<void> keluar() => _auth.signOut();

  static String pesanError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan masuk.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan (${e.code}).';
    }
  }
}