import 'package:cloud_firestore/cloud_firestore.dart';

/// Model data Kendaraan.
/// Path Firestore: users/{uid}/kendaraan/{kendaraanId}
class KendaraanModel {
  final String id;
  final String nama;
  final String jenis; // "motor" | "mobil"
  final String platNomor;
  final DateTime? createdAt;

  KendaraanModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.platNomor,
    this.createdAt,
  });

  factory KendaraanModel.fromMap(String id, Map<String, dynamic> map) {
    return KendaraanModel(
      id: id,
      nama: map['nama'] ?? '',
      jenis: map['jenis'] ?? 'motor',
      platNomor: map['platNomor'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenis': jenis,
      'platNomor': platNomor,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  String get iconLabel => jenis == 'mobil' ? 'Mobil' : 'Motor';
}
