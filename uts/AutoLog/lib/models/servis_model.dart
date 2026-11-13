import 'package:cloud_firestore/cloud_firestore.dart';

/// Model data Servis.
/// Path Firestore: users/{uid}/servis/{servisId}
class ServisModel {
  final String id;
  final String kendaraanId;
  final DateTime tanggal;
  final String jenisServis;
  final double biaya;
  final String keterangan;
  final String? fotoUrl;
  final String? fotoPath;
  final DateTime? createdAt;

  ServisModel({
    required this.id,
    required this.kendaraanId,
    required this.tanggal,
    required this.jenisServis,
    required this.biaya,
    required this.keterangan,
    this.fotoUrl,
    this.fotoPath,
    this.createdAt,
  });

  factory ServisModel.fromMap(String id, Map<String, dynamic> map) {
    return ServisModel(
      id: id,
      kendaraanId: map['kendaraanId'] ?? '',
      tanggal: (map['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
      jenisServis: map['jenisServis'] ?? '',
      biaya: (map['biaya'] ?? 0).toDouble(),
      keterangan: map['keterangan'] ?? '',
      fotoUrl: map['fotoUrl'],
      fotoPath: map['fotoPath'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kendaraanId': kendaraanId,
      'tanggal': Timestamp.fromDate(tanggal),
      'jenisServis': jenisServis,
      'biaya': biaya,
      'keterangan': keterangan,
      'fotoUrl': fotoUrl,
      'fotoPath': fotoPath,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
