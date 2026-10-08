import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../models/kategori.dart';
import '../utils/format.dart';

class BarangCard extends StatelessWidget {
  final Barang barang;
  final VoidCallback onTap;

  const BarangCard({super.key, required this.barang, required this.onTap});

  IconData get _ikon => switch (barang.kategori) {
        Kategori.elektronik => Icons.devices,
        Kategori.atk => Icons.edit,
        Kategori.perabot => Icons.chair,
        Kategori.buku => Icons.menu_book, // Ikon kategori buku
      };

  @override
  Widget build(BuildContext context) {
    final stokMenipis = barang.stok <= 5;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Icon(_ikon)),
        title: Text(barang.nama),
        subtitle: Text('${barang.kode} · ${barang.harga.rupiah}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              barang.statusStok, // Menampilkan status stok
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: stokMenipis ? Colors.red : Colors.green,
              ),
            ),
            Text(
              '${barang.stok}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: stokMenipis ? Colors.red : null,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}