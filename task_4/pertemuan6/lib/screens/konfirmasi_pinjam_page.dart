import 'package:flutter/material.dart';
import '../models/buku.dart';

class KonfirmasiPinjamPage extends StatelessWidget {
  final Buku buku;

  const KonfirmasiPinjamPage({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin meminjam buku ini?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text('Judul: ${buku.judul}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Penulis: ${buku.penulis}'),
            Text('Tahun: ${buku.tahun}'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ya, Pinjam'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}