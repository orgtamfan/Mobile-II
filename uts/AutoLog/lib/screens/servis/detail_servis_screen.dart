import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../models/servis_model.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_button.dart';

/// F-DATA-05: Detail servis + foto nota. F-STR-04: Hapus foto + data.
class DetailServisScreen extends StatefulWidget {
  final ServisModel servis;

  const DetailServisScreen({super.key, required this.servis});

  @override
  State<DetailServisScreen> createState() => _DetailServisScreenState();
}

class _DetailServisScreenState extends State<DetailServisScreen> {
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();
  bool _isDeleting = false;

  Future<void> _hapusServis() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Servis'),
        content: const Text(
            'Yakin ingin menghapus data servis ini beserta foto notanya? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isDeleting = true);

    try {
      // Hapus foto dari Storage terlebih dahulu (jika ada).
      if (widget.servis.fotoPath != null) {
        await _storageService.hapusFoto(widget.servis.fotoPath!);
      }
      // Lalu hapus dokumen servis dari Firestore.
      await _firestoreService.hapusServis(uid, widget.servis.id);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servis = widget.servis;
    final tanggalStr =
        DateFormat('dd MMMM yyyy', 'id_ID').format(servis.tanggal);
    final biayaStr = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(servis.biaya);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Servis')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (servis.fotoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    servis.fotoUrl!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 220,
                        alignment: Alignment.center,
                        color: Colors.grey.shade100,
                        child: const CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      alignment: Alignment.center,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 160,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Tidak ada foto nota',
                      style: TextStyle(color: Colors.grey.shade500)),
                ),
              const SizedBox(height: 20),

              Text(
                servis.jenisServis,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(tanggalStr, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 16),

              _InfoRow(label: 'Biaya', value: biayaStr),
              const Divider(height: 24),
              _InfoRow(
                  label: 'Keterangan',
                  value: servis.keterangan.isEmpty
                      ? '-'
                      : servis.keterangan),

              const SizedBox(height: 32),
              CustomButton(
                label: 'Hapus Servis',
                icon: Icons.delete_outline,
                color: Colors.red.shade600,
                isLoading: _isDeleting,
                onPressed: _hapusServis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
