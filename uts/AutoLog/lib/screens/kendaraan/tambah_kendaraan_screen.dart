import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/kendaraan_model.dart';
import '../../widgets/custom_button.dart';

class TambahKendaraanScreen extends StatefulWidget {
  const TambahKendaraanScreen({super.key});

  @override
  State<TambahKendaraanScreen> createState() => _TambahKendaraanScreenState();
}

class _TambahKendaraanScreenState extends State<TambahKendaraanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _platController = TextEditingController();
  final _firestoreService = FirestoreService();

  String _jenis = 'motor';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _namaController.dispose();
    _platController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final kendaraan = KendaraanModel(
        id: '',
        nama: _namaController.text.trim(),
        jenis: _jenis,
        platNomor: _platController.text.trim().toUpperCase(),
      );
      await _firestoreService.tambahKendaraan(uid, kendaraan);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _errorMessage = 'Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kendaraan')),
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
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kendaraan',
                    hintText: 'Contoh: Honda Vario 125',
                    prefixIcon: Icon(Icons.label_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Nama kendaraan tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),
                Text('Jenis Kendaraan',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _JenisChip(
                        label: 'Motor',
                        icon: Icons.two_wheeler,
                        selected: _jenis == 'motor',
                        onTap: () => setState(() => _jenis = 'motor'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _JenisChip(
                        label: 'Mobil',
                        icon: Icons.directions_car,
                        selected: _jenis == 'mobil',
                        onTap: () => setState(() => _jenis = 'mobil'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _platController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Plat Nomor',
                    hintText: 'Contoh: B 1234 ABC',
                    prefixIcon: Icon(Icons.pin_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Plat nomor tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Simpan Kendaraan',
                  isLoading: _isLoading,
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

class _JenisChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _JenisChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF1E3A5F) : Colors.grey.shade400;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(10),
          color: selected ? color.withValues(alpha: 0.08) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
