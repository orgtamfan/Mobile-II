import '../models/barang.dart';
import '../models/barang_atk.dart';
import '../models/barang_buku.dart';
import '../models/barang_elektronik.dart';
import '../models/barang_perabot.dart';

final List<Barang> dataBarang = [
  BarangElektronik(
    kode: 'ELK-001',
    nama: 'Laptop Asus Vivobook',
    harga: 8500000,
    stok: 5,
    garansiBulan: 24,
    persenDiskon: 10, // Diskon 10%
    tanggalMasuk: DateTime(2025, 1, 15),
  ),
  BarangElektronik(
    kode: 'ELK-002',
    nama: 'Proyektor Epson',
    harga: 6200000,
    stok: 2,
    garansiBulan: 12,
    catatan: 'Disimpan di Lab 2',
    tanggalMasuk: DateTime(2025, 2, 10),
  ),
  BarangAtk(
    kode: 'ATK-001',
    nama: 'Kertas A4 80 gsm',
    harga: 52000,
    stok: 40,
    satuan: 'rim',
    tanggalMasuk: DateTime(2025, 3, 1),
  ),
  BarangAtk(
    kode: 'ATK-002',
    nama: 'Spidol Whiteboard',
    harga: 9000,
    stok: 24,
    satuan: 'pcs',
  ),
  BarangPerabot(
    kode: 'PRB-001',
    nama: 'Kursi Kuliah',
    harga: 450000,
    stok: 60,
    bahan: 'Besi dan plastik',
  ),
  BarangPerabot(
    kode: 'PRB-002',
    nama: 'Meja Dosen',
    harga: 1200000,
    stok: 8,
    bahan: 'Kayu jati',
    catatan: 'Ruang dosen lantai 2',
  ),
  // Tugas 2: Data sampel buku
  BarangBuku(
    kode: 'BKU-001',
    nama: 'Pemrograman Flutter & Dart',
    harga: 125000,
    stok: 15,
    penulis: 'Erico Darmawan',
    tanggalMasuk: DateTime(2025, 2, 20),
  ),
  BarangBuku(
    kode: 'BKU-002',
    nama: 'Dasar-Dasar OOP',
    harga: 95000,
    stok: 0,
    penulis: 'Budi Raharjo',
  ),
];