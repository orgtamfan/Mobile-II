import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kendaraan_model.dart';
import '../models/servis_model.dart';
import '../models/notifikasi_model.dart';

/// Service untuk semua operasi CRUD ke Firestore.
/// Semua data disimpan di bawah users/{uid}/... agar hanya bisa
/// diakses oleh pemiliknya (F-AUTH-07 & aturan keamanan Firestore).
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _kendaraanRef(String uid) =>
      _db.collection('users').doc(uid).collection('kendaraan');

  CollectionReference<Map<String, dynamic>> _servisRef(String uid) =>
      _db.collection('users').doc(uid).collection('servis');

  CollectionReference<Map<String, dynamic>> _notifikasiRef(String uid) =>
      _db.collection('users').doc(uid).collection('notifikasi');

  // ---------------- Kendaraan ----------------

  Future<void> tambahKendaraan(String uid, KendaraanModel kendaraan) async {
    await _kendaraanRef(uid).add(kendaraan.toMap());
  }

  Stream<List<KendaraanModel>> streamKendaraan(String uid) {
    return _kendaraanRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => KendaraanModel.fromMap(d.id, d.data()))
            .toList());
  }

  Future<KendaraanModel?> getKendaraan(String uid, String kendaraanId) async {
    final doc = await _kendaraanRef(uid).doc(kendaraanId).get();
    if (!doc.exists) return null;
    return KendaraanModel.fromMap(doc.id, doc.data()!);
  }

  // ---------------- Servis ----------------

  /// Menambah dokumen servis baru. Mengembalikan ID dokumen agar
  /// bisa dipakai sebagai nama file foto (nota_servis/{uid}/{servisId}.jpg).
  Future<String> buatDraftServis(String uid, ServisModel servis) async {
    final doc = await _servisRef(uid).add(servis.toMap());
    return doc.id;
  }

  Future<void> updateFotoServis({
    required String uid,
    required String servisId,
    required String fotoUrl,
    required String fotoPath,
  }) async {
    await _servisRef(uid).doc(servisId).update({
      'fotoUrl': fotoUrl,
      'fotoPath': fotoPath,
    });
  }

  Stream<List<ServisModel>> streamServisByKendaraan(
    String uid,
    String kendaraanId,
  ) {
    return _servisRef(uid)
        .where('kendaraanId', isEqualTo: kendaraanId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ServisModel.fromMap(d.id, d.data())).toList());
  }

  Future<ServisModel?> getServis(String uid, String servisId) async {
    final doc = await _servisRef(uid).doc(servisId).get();
    if (!doc.exists) return null;
    return ServisModel.fromMap(doc.id, doc.data()!);
  }

  Future<void> hapusServis(String uid, String servisId) async {
    await _servisRef(uid).doc(servisId).delete();
  }

  // ---------------- Notifikasi ----------------

  Future<void> simpanNotifikasi(String uid, NotifikasiModel notif) async {
    await _notifikasiRef(uid).add(notif.toMap());
  }

  Stream<List<NotifikasiModel>> streamNotifikasi(String uid) {
    return _notifikasiRef(uid)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => NotifikasiModel.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> tandaiNotifikasiDibaca(String uid, String notifId) async {
    await _notifikasiRef(uid).doc(notifId).update({'sudahDibaca': true});
  }

  // ---------------- User / FCM Token ----------------

  Future<void> simpanFcmToken(String uid, String token) async {
    await _db.collection('users').doc(uid).set(
      {'fcmToken': token},
      SetOptions(merge: true),
    );
  }

  Future<String?> getUserEmail(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['email'];
  }
}
