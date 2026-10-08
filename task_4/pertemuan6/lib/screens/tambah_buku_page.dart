import 'package:flutter/material.dart';
import '../models/buku.dart';

class TambahBukuPage extends StatefulWidget {
  const TambahBukuPage({super.key});

  @override
  State<TambahBukuPage> createState() => _TambahBukuPageState();
}

class _TambahBukuPageState extends State<TambahBukuPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _penulisCtrl = TextEditingController();
  final _tahunCtrl = TextEditingController();
  final _sinopsisCtrl = TextEditingController();

  @override
  void dispose() {
    _judulCtrl.dispose();
    _penulisCtrl.dispose();
    _tahunCtrl.dispose();
    _sinopsisCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final bukuBaru = Buku(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        judul: _judulCtrl.text.trim(),
        penulis: _penulisCtrl.text.trim(),
        tahun: int.parse(_tahunCtrl.text.trim()),
        sinopsis: _sinopsisCtrl.text.trim(),
      );
      Navigator.pop(context, bukuBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Buku Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulCtrl,
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                validator: (val) => val == null || val.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _penulisCtrl,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (val) => val == null || val.isEmpty ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tahunCtrl,
                decoration: const InputDecoration(labelText: 'Tahun Terbit'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Tahun wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sinopsisCtrl,
                decoration: const InputDecoration(labelText: 'Sinopsis'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Sinopsis wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _simpan,
                child: const Text('Simpan Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}