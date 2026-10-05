import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../utils/format.dart';

class DetailBarangPage extends StatefulWidget {
  final Barang barang;
  const DetailBarangPage({super.key, required this.barang});

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  Barang get _b => widget.barang;

  void _tambah() {
    setState(() => _b.tambahStok(1));
  }

  void _kurangi() {
    var berhasil = false;
    setState(() => berhasil = _b.kurangiStok(1));
    if (!berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stok tidak mencukupi')),
      );
    }
  }

  Widget _baris(String label, String nilai) {
    return ListTile(
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(nilai, style: const TextStyle(fontSize: 16, color: Colors.black87)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_b.nama)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                _baris('Kode', _b.kode),
                const Divider(height: 1),
                _baris('Kategori', _b.kategori.label),
                const Divider(height: 1),
                _baris('Harga', formatRupiah(_b.harga)),
                const Divider(height: 1),
                _baris('Informasi Khusus', _b.detail),
                const Divider(height: 1),
                // ?? : tampilkan teks cadangan jika catatan bernilai null
                _baris('Catatan', _b.catatan ?? 'Tidak ada catatan'),
                const Divider(height: 1),
                _baris('Nilai Stok', formatRupiah(_b.nilaiStok)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('Stok', style: Theme.of(context).textTheme.labelLarge),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: _kurangi,
                icon: const Icon(Icons.remove),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${_b.stok}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton.filledTonal(
                onPressed: _tambah,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}