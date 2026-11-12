import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'foto_service.dart';

class ProfilService {
  static const int batasFotoProfilKarakter = 100000;
  final FotoService _foto = FotoService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Stream<DocumentSnapshot<Map<String, dynamic>>> perubahanProfil() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<Uint8List?> pilihFotoProfil() => _foto.pilihFotoProfil();

  Future<void> simpanFotoProfil(Uint8List bytes) async {
    final uid = _uid;
    if (uid == null) throw StateError('Pengguna belum masuk.');
    final kode = FotoService.kodekan(bytes);
    if (kode.length >= batasFotoProfilKarakter) {
      throw StateError('Foto profil melebihi batas 100.000 karakter.');
    }
    await _firestore.collection('users').doc(uid).set({
      'fotoProfil': kode,
    }, SetOptions(merge: true));
  }

  Future<void> hapusFotoProfil() async {
    final uid = _uid;
    if (uid == null) return;
    final doc = _firestore.collection('users').doc(uid);
    final profil = await doc.get();
    if (profil.data()?['fotoProfil'] is! String) return;
    await doc.update({'fotoProfil': FieldValue.delete()});
  }
}
