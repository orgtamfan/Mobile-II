import 'barang.dart';
import 'kategori.dart';

class BarangAtk extends Barang {
  final String satuan;

  BarangAtk({
    required super.kode,
    required super.nama,
    required super.harga,
    required super.stok,
    super.catatan,
    required this.satuan,
  });

  @override
  Kategori get kategori => Kategori.atk;

  @override
  String get detail => 'Satuan: $satuan';
}