import 'barang.dart';
import 'diskon.dart';
import 'kategori.dart';

class BarangElektronik extends Barang with Diskon {
  final int garansiBulan;
  @override
  final double persenDiskon;

  BarangElektronik({
    required super.kode,
    required super.nama,
    required super.harga,
    required super.stok,
    super.catatan,
    super.tanggalMasuk,
    required this.garansiBulan,
    this.persenDiskon = 0.0,
  });

  @override
  Kategori get kategori => Kategori.elektronik;

  @override
  String get detail => 'Garansi $garansiBulan bulan';
}