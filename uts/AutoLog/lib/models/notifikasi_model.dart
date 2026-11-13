import 'package:cloud_firestore/cloud_firestore.dart';

/// Model data Notifikasi.
/// Path Firestore: users/{uid}/notifikasi/{notifId}
class NotifikasiModel {
  final String id;
  final String judul;
  final String pesan;
  final DateTime tanggal;
  final bool sudahDibaca;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tanggal,
    required this.sudahDibaca,
  });

  factory NotifikasiModel.fromMap(String id, Map<String, dynamic> map) {
    return NotifikasiModel(
      id: id,
      judul: map['judul'] ?? '',
      pesan: map['pesan'] ?? '',
      tanggal: (map['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sudahDibaca: map['sudahDibaca'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'pesan': pesan,
      'tanggal': Timestamp.fromDate(tanggal),
      'sudahDibaca': sudahDibaca,
    };
  }
}
