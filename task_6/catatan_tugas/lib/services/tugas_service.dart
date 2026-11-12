import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tugas.dart';

class TugasService {
  final CollectionReference<Map<String, dynamic>> _ref = FirebaseFirestore
      .instance
      .collection('tugas');

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> tambah(Tugas t) {
    return _ref.add({
      ...t.toMap(),
      'uid': _uid,
      'dibuat': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Tugas>> semua() {
    return _ref
        .where('uid', isEqualTo: _uid)
        .orderBy('dibuat', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Tugas.fromDoc(d)).toList());
  }

  Future<Tugas?> ambil(String id) async {
    final doc = await _ref.doc(id).get();
    if (!doc.exists) return null;
    final tugas = Tugas.fromDoc(doc);
    return tugas.uid == _uid ? tugas : null;
  }

  Future<void> ubah(Tugas t, {bool hapusLampiran = false}) {
    return _ref.doc(t.id).update({
      ...t.toMap(),
      if (hapusLampiran) 'lampiranBase64': FieldValue.delete(),
    });
  }

  Future<void> setSelesai(String id, bool nilai) {
    return _ref.doc(id).update({'selesai': nilai});
  }

  Future<void> hapus(String id) {
    return _ref.doc(id).delete();
  }
}
