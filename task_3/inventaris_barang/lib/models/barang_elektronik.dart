import 'barang.dart';
import 'kategori.dart';

class BarangElektronik extends Barang {
  final int garansiBulan;

  BarangElektronik({
    required super.kode,
    required super.nama,
    required super.harga,
    required super.stok,
    super.catatan,
    required this.garansiBulan,
  });

  @override
  Kategori get kategori => Kategori.elektronik;

  @override
  String get detail => 'Garansi $garansiBulan bulan';
}