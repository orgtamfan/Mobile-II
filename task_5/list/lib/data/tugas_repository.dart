import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tugas.dart';

class TugasRepository {
  static const _kunci = 'daftar_tugas';
  static const _kunsiFilter = 'filter_pilihan';
  static const _kunsiUrutan = 'urutan_pilihan';

  Future<List<Tugas>> muat() async {
    // simulasi waktu tunggu jaringan
    await Future.delayed(const Duration(milliseconds: 800));
    final prefs = await SharedPreferences.getInstance();
    final teks = prefs.getString(_kunci);
    if (teks == null) return _contoh(); // belum pernah disimpan
    final daftar = jsonDecode(teks) as List<dynamic>;
    return daftar.map((e) => Tugas.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> simpan(List<Tugas> daftar) async {
    final prefs = await SharedPreferences.getInstance();
    final teks = jsonEncode(daftar.map((t) => t.toMap()).toList());
    await prefs.setString(_kunci, teks);
  }

  Future<String?> muatFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kunsiFilter);
  }

  Future<void> simpanFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunsiFilter, filter);
  }

  Future<String?> muatUrutan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kunsiUrutan);
  }

  Future<void> simpanUrutan(String urutan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunsiUrutan, urutan);
  }

  List<Tugas> buatContohBag2(int mulaiDari) {
    final now = DateTime.now();
    final contoh = <Tugas>[];
    final matkul = [
      'Pemrograman Mobile',
      'Basis Data',
      'Etika Profesi',
      'Jaringan Komputer',
      'Rekayasa PL',
      'Algoritma',
      'Web Development',
      'Mobile Development',
    ];
    final judul = [
      'Laporan ',
      'Kuis ',
      'Makalah ',
      'Rangkuman ',
      'Slide Presentasi ',
      'Latihan ',
      'Project ',
      'Tugas ',
    ];

    for (int i = 0; i < 40; i++) {
      contoh.add(
        Tugas(
          id: 'SAMPLE_${mulaiDari + i}',
          judul: '${judul[i % judul.length]}${i + 1}',
          matkul: matkul[i % matkul.length],
          tenggat: now.add(Duration(days: (i % 14) - 3)),
          prioritas: Prioritas.values[i % 3],
          selesai: i % 5 == 0,
        ),
      );
    }
    return contoh;
  }

  List<Tugas> _contoh() {
    final now = DateTime.now();
    return [
      Tugas(
        id: 'T1',
        judul: 'Laporan Flutter',
        matkul: 'Pemrograman Mobile',
        tenggat: now.add(const Duration(days: 2)),
        prioritas: Prioritas.tinggi,
      ),
      Tugas(
        id: 'T2',
        judul: 'Kuis Basis Data',
        matkul: 'Basis Data',
        tenggat: now.add(const Duration(days: 1)),
      ),
      Tugas(
        id: 'T3',
        judul: 'Makalah Etika',
        matkul: 'Etika Profesi',
        tenggat: now.add(const Duration(days: 5)),
        prioritas: Prioritas.rendah,
      ),
      Tugas(
        id: 'T4',
        judul: 'Rangkuman Jarkom',
        matkul: 'Jaringan Komputer',
        tenggat: now.subtract(const Duration(days: 1)),
      ),
      Tugas(
        id: 'T5',
        judul: 'Slide Presentasi RPL',
        matkul: 'Rekayasa PL',
        tenggat: now.add(const Duration(days: 7)),
        prioritas: Prioritas.tinggi,
      ),
      Tugas(
        id: 'T6',
        judul: 'Latihan Algoritma',
        matkul: 'Algoritma',
        tenggat: now.add(const Duration(days: 3)),
        prioritas: Prioritas.rendah,
        selesai: true,
      ),
    ];
  }
}
