import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tugas {
  final String? id;
  final String? uid;
  final String judul;
  final String mataKuliah;
  final String deskripsi;
  final bool selesai;
  final DateTime? dibuat;
  final String? lampiranBase64;

  Tugas({
    this.id,
    this.uid,
    required this.judul,
    required this.mataKuliah,
    this.deskripsi = '',
    this.selesai = false,
    this.dibuat,
    this.lampiranBase64,
  });

  factory Tugas.fromDoc(DocumentSnapshot> doc) {
    final data = doc.data() ?? {};
    return Tugas(
      id: doc.id,
      uid: data['uid'],
      judul: data['judul'] ?? '',
      mataKuliah: data['matakuliah'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      selesai: data['selesai'] ?? false,
      dibuat: (data['dibuat'] as Timestamp?)?.toDate(),
      lampiranBase64: data['lampiranBase64'],
    );
  }

  Map<String, dynamic> toMap() => {
        'judul': judul,
        'matakuliah': mataKuliah,
        'deskripsi': deskripsi,
        'selesai': selesai,
        if (lampiranBase64 != null) 'lampiranBase64': lampiranBase64,
      };

  Uint8List? get fotoBytes {
    final k = lampiranBase64;
    if (k == null || k.isEmpty) return null;
    try {
      return base64Decode(k);
    } catch (_) {
      return null;
    }
  }
}