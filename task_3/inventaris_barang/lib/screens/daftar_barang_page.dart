import 'package:flutter/material.dart';
import '../data/data_barang.dart';
import '../models/barang.dart';
import '../models/kategori.dart';
import '../utils/format.dart';
import '../widgets/barang_card.dart';
import 'detail_barang_page.dart';
import 'tambah_barang_page.dart';

class DaftarBarangPage extends StatefulWidget {
  const DaftarBarangPage({super.key});

  @override
  State<DaftarBarangPage> createState() => _DaftarBarangPageState();
}

class _DaftarBarangPageState extends State<DaftarBarangPage> {
  Kategori? _filter;
  String _kataKunci = ''; // Tugas 5: pencarian kata kunci

  // Tugas 5: Filter gabungan kategori dan pencarian nama
  List<Barang> get _tampil {
    return dataBarang.where((b) {
      final cocokKategori = _filter == null || b.kategori == _filter;
      final cocokNama = _kataKunci.isEmpty ||
          b.nama.toLowerCase().contains(_kataKunci.toLowerCase()) ||
          b.kode.toLowerCase().contains(_kataKunci.toLowerCase());
      return cocokKategori && cocokNama;
    }).toList();
  }

  double get _totalNilai =>
      _tampil.fold(0.0, (jumlah, b) => jumlah + b.nilaiStok);

  Future<void> _bukaDetail(Barang b) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailBarangPage(barang: b)),
    );
    if (!mounted) return;
    setState(() {});
  }

  // Tugas 6: Membuka form tambah barang
  Future<void> _tambahBarang() async {
    final Barang? barangBaru = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TambahBarangPage()),
    );

    if (barangBaru != null) {
      setState(() {
        dataBarang.add(barangBaru);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _tampil;
    return Scaffold(
      appBar: AppBar(title: const Text('Inventaris Barang')),
      body: Column(
        children: [
          // Tugas 5: Field pencarian nama
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama atau kode barang...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (val) => setState(() => _kataKunci = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: _filter == null,
                      onSelected: (_) => setState(() => _filter = null),
                    ),
                    const SizedBox(width: 8),
                    for (final k in Kategori.values) ...[
                      ChoiceChip(
                        label: Text(k.label),
                        selected: _filter == k,
                        onSelected: (_) => setState(() => _filter = k),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${data.length} barang · Total nilai stok ${_totalNilai.rupiah}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text('Barang tidak ditemukan'))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final b = data[index];
                      return BarangCard(barang: b, onTap: () => _bukaDetail(b));
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahBarang,
        child: const Icon(Icons.add),
      ),
    );
  }
}