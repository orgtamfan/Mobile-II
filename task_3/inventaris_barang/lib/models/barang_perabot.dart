import 'barang.dart';
import 'kategori.dart';

class BarangPerabot extends Barang {
  final String bahan;

  BarangPerabot({
    required super.kode,
    required super.nama,
    required super.harga,
    required super.stok,
    super.catatan,
    required this.bahan,
  });

  @override
  Kategori get kategori => Kategori.perabot;

  @override
  String get detail => 'Bahan: $bahan';
}