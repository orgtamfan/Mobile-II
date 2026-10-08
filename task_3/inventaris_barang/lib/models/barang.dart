import 'kategori.dart';

abstract class Barang {
  final String kode;
  final String nama;
  final double harga;
  final String? catatan;
  final DateTime? tanggalMasuk; // Tugas 4
  int _stok;

  Barang({
    required this.kode,
    required this.nama,
    required this.harga,
    required int stok,
    this.catatan,
    this.tanggalMasuk,
  }) : _stok = stok;

  int get stok => _stok;
  double get nilaiStok => harga * _stok;

  // Tugas 1: Getter status stok
  String get statusStok {
    if (_stok == 0) return 'Habis';
    if (_stok <= 5) return 'Menipis';
    return 'Aman';
  }

  Kategori get kategori;
  String get detail;

  void tambahStok(int jumlah) {
    if (jumlah > 0) _stok += jumlah;
  }

  bool kurangiStok(int jumlah) {
    if (jumlah <= 0 || jumlah > _stok) return false;
    _stok -= jumlah;
    return true;
  }

  @override
  String toString() => '$kode - $nama (stok: $_stok)';
}