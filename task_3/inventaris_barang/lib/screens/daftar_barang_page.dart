import 'package:flutter/material.dart';
import '../data/data_barang.dart';
import '../models/barang.dart';
import '../models/kategori.dart';
import '../utils/format.dart';
import '../widgets/barang_card.dart';
import 'detail_barang_page.dart';

class DaftarBarangPage extends StatefulWidget {
  const DaftarBarangPage({super.key});

  @override
  State<DaftarBarangPage> createState() => _DaftarBarangPageState();
}

class _DaftarBarangPageState extends State<DaftarBarangPage> {
  Kategori? _filter; // nullable: null berarti "Semua kategori"

  // Daftar yang ditampilkan: hasil penyaringan dataBarang
  List<Barang> get _tampil => _filter == null
      ? dataBarang
      : dataBarang.where((b) => b.kategori == _filter).toList();

  double get _totalNilai =>
      _tampil.fold(0.0, (jumlah, b) => jumlah + b.nilaiStok);

  Future<void> _bukaDetail(Barang b) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailBarangPage(barang: b)),
    );
    if (!mounted) return;
    setState(() {}); // segarkan daftar: stok mungkin berubah di halaman detail
  }

  @override
  Widget build(BuildContext context) {
    final data = _tampil;
    return Scaffold(
      appBar: AppBar(title: const Text('Inventaris Barang')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: _filter == null,
                    onSelected: (_) => setState(() => _filter = null),
                  ),
                  // collection for: satu chip untuk setiap nilai enum
                  for (final k in Kategori.values)
                    ChoiceChip(
                      label: Text(k.label),
                      selected: _filter == k,
                      onSelected: (_) => setState(() => _filter = k),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${data.length} barang · Total nilai stok '
                '${formatRupiah(_totalNilai)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final b = data[index];
                return BarangCard(barang: b, onTap: () => _bukaDetail(b));
              },
            ),
          ),
        ],
      ),
    );
  }
}