import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../models/kendaraan_model.dart';
import '../../models/servis_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';

/// F-DATA-03 & F-STR-01/02: Form tambah servis + upload foto nota dengan progress.
class TambahServisScreen extends StatefulWidget {
  final KendaraanModel kendaraan;

  const TambahServisScreen({super.key, required this.kendaraan});

  @override
  State<TambahServisScreen> createState() => _TambahServisScreenState();
}

class _TambahServisScreenState extends State<TambahServisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jenisServisController = TextEditingController();
  final _biayaController = TextEditingController();
  final _keteranganController = TextEditingController();

  final _firestoreService = FirestoreService();
  final _storageService = StorageService();
  final _imagePicker = ImagePicker();

  DateTime _tanggal = DateTime.now();
  File? _fotoFile;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _jenisServisController.dispose();
    _biayaController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  Future<void> _pilihFoto(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _fotoFile = File(picked.path));
    }
  }

  void _tampilkanPilihanSumberFoto() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pilihFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pilihFoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      // 1. Buat dokumen servis dulu (tanpa foto) untuk mendapatkan servisId.
      final servis = ServisModel(
        id: '',
        kendaraanId: widget.kendaraan.id,
        tanggal: _tanggal,
        jenisServis: _jenisServisController.text.trim(),
        biaya: double.tryParse(
                _biayaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            0,
        keterangan: _keteranganController.text.trim(),
      );

      final servisId =
          await _firestoreService.buatDraftServis(uid, servis);

      // 2. Jika ada foto, upload ke Storage dengan progress.
      if (_fotoFile != null) {
        setState(() => _isUploading = true);

        final hasil = await _storageService.uploadFotoNota(
          uid: uid,
          servisId: servisId,
          file: _fotoFile!,
          onProgress: (progress) {
            if (mounted) setState(() => _uploadProgress = progress);
          },
        );

        await _firestoreService.updateFotoServis(
          uid: uid,
          servisId: servisId,
          fotoUrl: hasil['fotoUrl']!,
          fotoPath: hasil['fotoPath']!,
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _errorMessage = 'Gagal menyimpan servis: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanggalStr = DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggal);

    return Scaffold(
      appBar: AppBar(title: const Text('Catat Servis')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_errorMessage!,
                        style: TextStyle(color: Colors.red.shade700)),
                  ),

                // Tanggal
                Text('Tanggal Servis',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pilihTanggal,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(tanggalStr),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _jenisServisController,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Servis',
                    hintText: 'Contoh: Ganti Oli, Servis Rutin',
                    prefixIcon: Icon(Icons.build_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Jenis servis tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _biayaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Biaya (Rp)',
                    hintText: 'Contoh: 150000',
                    prefixIcon: Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Biaya tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _keteranganController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                    hintText: 'Catatan tambahan tentang servis ini',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                Text('Foto Nota Servis',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _tampilkanPilihanSumberFoto,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _fotoFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined,
                                  color: Colors.grey.shade500, size: 32),
                              const SizedBox(height: 8),
                              Text('Ketuk untuk tambah foto nota',
                                  style:
                                      TextStyle(color: Colors.grey.shade500)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_fotoFile!, fit: BoxFit.cover),
                          ),
                  ),
                ),

                if (_isUploading) ...[
                  const SizedBox(height: 12),
                  UploadProgressBar(progress: _uploadProgress),
                ],

                const SizedBox(height: 24),
                CustomButton(
                  label: 'Simpan Servis',
                  isLoading: _isSaving,
                  onPressed: _simpan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
