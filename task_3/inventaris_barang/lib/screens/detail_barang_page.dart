import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../models/diskon.dart';
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

  String _formatTanggal(DateTime? dt) {
    if (dt == null) return 'Belum dicatat'; // Tugas 4: null aware
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final b = _b;
    final adaDiskon = b is Diskon && (b as Diskon).persenDiskon > 0;

    return Scaffold(
      appBar: AppBar(title: Text(b.nama)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                _baris('Kode', b.kode),
                const Divider(height: 1),
                _baris('Kategori', b.kategori.label),
                const Divider(height: 1),
                _baris('Harga', b.harga.rupiah),
                if (adaDiskon) ...[
                  const Divider(height: 1),
                  _baris(
                    'Harga Diskon (${(b as Diskon).persenDiskon.toInt()}%)',
                    (b as Diskon).hargaSetelahDiskon(b.harga).rupiah,
                  ),
                ],
                const Divider(height: 1),
                _baris('Status Stok', b.statusStok),
                const Divider(height: 1),
                _baris('Informasi Khusus', b.detail),
                const Divider(height: 1),
                _baris('Tanggal Masuk', _formatTanggal(b.tanggalMasuk)),
                const Divider(height: 1),
                _baris('Catatan', b.catatan ?? 'Tidak ada catatan'),
                const Divider(height: 1),
                _baris('Nilai Stok', b.nilaiStok.rupiah),
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
                  '${b.stok}',
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