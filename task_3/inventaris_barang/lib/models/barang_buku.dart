import 'barang.dart';
import 'kategori.dart';

class BarangBuku extends Barang {
  final String penulis;

  BarangBuku({
    required super.kode,
    required super.nama,
    required super.harga,
    required super.stok,
    super.catatan,
    super.tanggalMasuk,
    required this.penulis,
  });

  @override
  Kategori get kategori => Kategori.buku;

  @override
  String get detail => 'Penulis: $penulis';
}