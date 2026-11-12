import 'package:flutter/material.dart';
import '../models/tugas.dart';
import '../services/tugas_service.dart';

class FormPage extends StatefulWidget {
  final Tugas? tugas;
  const FormPage({super.key, this.tugas});

  @override
  State<FormPage> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = TugasService();

  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  late final TextEditingController _deskripsi;

  bool _menyimpan = false;
  bool get _edit => widget.tugas != null;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.tugas?.judul ?? '');
    _mataKuliah = TextEditingController(text: widget.tugas?.mataKuliah ?? '');
    _deskripsi = TextEditingController(text: widget.tugas?.deskripsi ?? '');
  }

  @override
  void dispose() {
    _judul.dispose();
    _mataKuliah.dispose();
    _deskripsi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _menyimpan = true);

    final lama = widget.tugas;
    try {
      final t = Tugas(
        id: lama?.id,
        judul: _judul.text.trim(),
        mataKuliah: _mataKuliah.text.trim(),
        deskripsi: _deskripsi.text.trim(),
        selesai: lama?.selesai ?? false,
      );

      if (_edit) {
        await _service.ubah(t);
      } else {
        await _service.tambah(t);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _menyimpan = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_edit ? 'Ubah Tugas' : 'Tambah Tugas')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mataKuliah,
              decoration: const InputDecoration(
                labelText: 'Mata Kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Mata kuliah wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deskripsi,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _menyimpan ? null : _simpan,
                child: Text(_edit ? 'SIMPAN PERUBAHAN' : 'SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}