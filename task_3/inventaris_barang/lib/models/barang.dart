import 'kategori.dart';

/// Kelas abstrak: tidak bisa dibuat objeknya langsung (Barang(...) = error).
/// Hanya subclass (BarangElektronik, BarangAtk, BarangPerabot) yang bisa.
abstract class Barang {
  final String kode;
  final String nama;
  final double harga;
  final String? catatan; // opsional: boleh null
  int _stok; // private: hanya bisa diubah lewat method di bawah

  Barang({
    required this.kode,
    required this.nama,
    required this.harga,
    required int stok,
    this.catatan,
  }) : _stok = stok;

  // Getter: membaca stok tanpa membuka akses untuk mengubahnya langsung
  int get stok => _stok;
  double get nilaiStok => harga * _stok;

  // Anggota abstrak: wajib diisi oleh setiap subclass
  Kategori get kategori;
  String get detail;

  void tambahStok(int jumlah) {
    if (jumlah > 0) _stok += jumlah;
  }

  /// Mengembalikan false jika jumlah tidak valid atau stok tidak cukup.
  bool kurangiStok(int jumlah) {
    if (jumlah <= 0 || jumlah > _stok) return false;
    _stok -= jumlah;
    return true;
  }

  @override
  String toString() => '$kode - $nama (stok: $_stok)';
}