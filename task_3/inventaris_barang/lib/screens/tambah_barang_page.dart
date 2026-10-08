import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../models/barang_atk.dart';
import '../models/barang_buku.dart';
import '../models/barang_elektronik.dart';
import '../models/barang_perabot.dart';
import '../models/kategori.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();

  String _kode = '';
  String _nama = '';
  double _harga = 0;
  int _stok = 0;
  String? _catatan;
  Kategori _kategori = Kategori.elektronik;
  String _detailKhusus = '';

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Barang barangBaru;
      final tgl = DateTime.now();

      switch (_kategori) {
        case Kategori.elektronik:
          barangBaru = BarangElektronik(
            kode: _kode,
            nama: _nama,
            harga: _harga,
            stok: _stok,
            catatan: _catatan,
            tanggalMasuk: tgl,
            garansiBulan: int.tryParse(_detailKhusus) ?? 12,
          );
          break;
        case Kategori.atk:
          barangBaru = BarangAtk(
            kode: _kode,
            nama: _nama,
            harga: _harga,
            stok: _stok,
            catatan: _catatan,
            tanggalMasuk: tgl,
            satuan: _detailKhusus.isEmpty ? 'pcs' : _detailKhusus,
          );
          break;
        case Kategori.perabot:
          barangBaru = BarangPerabot(
            kode: _kode,
            nama: _nama,
            harga: _harga,
            stok: _stok,
            catatan: _catatan,
            tanggalMasuk: tgl,
            bahan: _detailKhusus.isEmpty ? 'Kayu' : _detailKhusus,
          );
          break;
        case Kategori.buku:
          barangBaru = BarangBuku(
            kode: _kode,
            nama: _nama,
            harga: _harga,
            stok: _stok,
            catatan: _catatan,
            tanggalMasuk: tgl,
            penulis: _detailKhusus.isEmpty ? 'Anonim' : _detailKhusus,
          );
          break;
      }

      Navigator.pop(context, barangBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<Kategori>(
              initialValue: _kategori,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: Kategori.values
                  .map((k) => DropdownMenuItem(value: k, child: Text(k.label)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _kategori = val);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kode Barang'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              onSaved: (v) => _kode = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Barang'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              onSaved: (v) => _nama = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              onSaved: (v) => _harga = double.parse(v!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Stok awal'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              onSaved: (v) => _stok = int.parse(v!),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: _kategori == Kategori.elektronik
                    ? 'Garansi (Bulan)'
                    : _kategori == Kategori.atk
                        ? 'Satuan (mis. rim, pcs)'
                        : _kategori == Kategori.perabot
                            ? 'Bahan'
                            : 'Penulis',
              ),
              onSaved: (v) => _detailKhusus = v ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Catatan (Opsional)'),
              onSaved: (v) => _catatan = v,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _simpan,
              child: const Text('Simpan Barang'),
            ),
          ],
        ),
      ),
    );
  }
}