import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../routes/app_routes.dart';

class DetailBukuPage extends StatefulWidget {
  final Buku buku;

  const DetailBukuPage({super.key, required this.buku});

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  Buku get _b => widget.buku;

  Future<void> _pinjamBuku() async {
    // Latihan 3: Membuka konfirmasi sebelum meminjam
    final yakin = await Navigator.pushNamed<bool>(
      context,
      AppRoutes.konfirmasi,
      arguments: _b,
    );

    if (yakin == true && mounted) {
      setState(() {
        _b.dipinjam = true; // Latihan 2: Mengubah status dipinjam
      });
      Navigator.pop(context, 'Buku "${_b.judul}" berhasil dipinjam');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_b.judul),
        actions: [
          IconButton(
            onPressed: () => setState(() => _b.favorit = !_b.favorit),
            icon: Icon(
              _b.favorit ? Icons.favorite : Icons.favorite_border,
              color: _b.favorit ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_b.judul, style: tema.headlineSmall),
          const SizedBox(height: 4),
          Text('${_b.penulis} ${_b.tahun}', style: tema.bodyMedium),
          const SizedBox(height: 12),
          // Latihan 2: Menampilkan status buku
          Chip(
            label: Text(_b.dipinjam ? 'Status: Dipinjam' : 'Status: Tersedia'),
            backgroundColor: _b.dipinjam ? Colors.orange.shade100 : Colors.teal.shade100,
          ),
          const SizedBox(height: 16),
          Text(_b.sinopsis, style: tema.bodyLarge),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            // Latihan 2: Nonaktifkan tombol jika sudah dipinjam
            onPressed: _b.dipinjam ? null : _pinjamBuku,
            icon: const Icon(Icons.bookmark_add),
            label: Text(_b.dipinjam ? 'Sudah Dipinjam' : 'Pinjam Buku'),
          ),
        ),
      ),
    );
  }
}