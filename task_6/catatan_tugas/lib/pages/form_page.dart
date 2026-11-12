import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/tugas.dart';
import '../services/foto_service.dart';
import '../services/tugas_service.dart';
import '../widgets/foto_base64.dart';

class FormPage extends StatefulWidget {
  final Tugas? tugas;

  const FormPage({super.key, this.tugas});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = TugasService();
  final _foto = FotoService();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  late final TextEditingController _deskripsi;
  Uint8List? _gambarBaru;
  bool _hapusLama = false;
  bool _menyimpan = false;

  bool get _edit => widget.tugas != null;
  bool get _adaGambar =>
      _gambarBaru != null ||
      (!_hapusLama && (widget.tugas?.lampiranBase64?.isNotEmpty ?? false));

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

  void _pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  Future<void> _pilih(ImageSource sumber) async {
    try {
      final data = await _foto.pilih(sumber);
      if (!mounted || data == null) return;
      if (data.length > FotoService.batasByte) {
        final kb = (data.length / 1024).toStringAsFixed(0);
        _pesan('Foto $kb KB melebihi batas 200 KB. Pilih foto lain.');
        return;
      }
      setState(() {
        _gambarBaru = data;
        _hapusLama = false;
      });
    } catch (error) {
      _pesan('Gagal memilih foto: $error');
    }
  }

  void _tampilPilihan() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pilih(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(ctx);
                _pilih(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _menyimpan = true);
    final lama = widget.tugas;
    try {
      final kode = _gambarBaru == null
          ? null
          : FotoService.kodekan(_gambarBaru!);
      final tugas = Tugas(
        id: lama?.id,
        judul: _judul.text.trim(),
        mataKuliah: _mataKuliah.text.trim(),
        deskripsi: _deskripsi.text.trim(),
        selesai: lama?.selesai ?? false,
        lampiranBase64: kode,
      );
      if (_edit) {
        await _service.ubah(tugas, hapusLampiran: _hapusLama && kode == null);
      } else {
        await _service.tambah(tugas);
      }
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) setState(() => _menyimpan = false);
      _pesan('Gagal menyimpan: $error');
    }
  }

  Widget _pratinjau() {
    final lama = widget.tugas?.lampiranBase64;
    final Widget? gambar;
    if (_gambarBaru != null) {
      gambar = Image.memory(
        _gambarBaru!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (!_hapusLama && lama != null && lama.isNotEmpty) {
      gambar = FotoBase64(kode: lama);
    } else {
      gambar = null;
    }
    return Container(
      height: 180,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          gambar ??
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                Text('Belum ada lampiran'),
              ],
            ),
          ),
    );
  }

  Widget? _indikatorUkuranFoto() {
    final foto = _gambarBaru;
    if (foto == null) return null;
    final kiloByte = foto.length / 1024;
    final perkiraanBase64 = ((foto.length + 2) ~/ 3) * 4;
    final peringatan = foto.length > 150 * 1024;
    final warna = peringatan ? Theme.of(context).colorScheme.error : null;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Ukuran foto: ${kiloByte.toStringAsFixed(0)} KB; Base64 sekitar '
        '${(perkiraanBase64 / 1024).toStringAsFixed(0)} KB'
        '${peringatan ? ' — mendekati batas 200 KB.' : ''}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: warna),
      ),
    );
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
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Judul wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mataKuliah,
              decoration: const InputDecoration(
                labelText: 'Mata Kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
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
            const SizedBox(height: 16),
            Text(
              'Lampiran Foto',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _pratinjau(),
            ?_indikatorUkuranFoto(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _menyimpan ? null : _tampilPilihan,
                  icon: const Icon(Icons.add_a_photo),
                  label: Text(_adaGambar ? 'Ganti Foto' : 'Pilih Foto'),
                ),
                if (_adaGambar)
                  TextButton.icon(
                    onPressed: _menyimpan
                        ? null
                        : () => setState(() {
                            if (_gambarBaru != null) {
                              _gambarBaru = null;
                            } else {
                              _hapusLama = true;
                            }
                          }),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _menyimpan ? null : _simpan,
                child: _menyimpan
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_edit ? 'SIMPAN PERUBAHAN' : 'SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
