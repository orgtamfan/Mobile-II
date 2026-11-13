import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/kendaraan_model.dart';
import '../servis/riwayat_servis_screen.dart';
import 'tambah_kendaraan_screen.dart';

/// Halaman daftar seluruh kendaraan milik user.
/// Ditampilkan juga sebagai bagian dari Home, dan dapat diakses
/// sebagai halaman tersendiri ("Lihat Semua Kendaraan").
class DaftarKendaraanScreen extends StatelessWidget {
  const DaftarKendaraanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kendaraan')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TambahKendaraanScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<KendaraanModel>>(
        stream: firestoreService.streamKendaraan(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return Center(
              child: Text('Belum ada kendaraan',
                  style: TextStyle(color: Colors.grey.shade600)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final kendaraan = list[index];
              final isMobil = kendaraan.jenis == 'mobil';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor:
                        const Color(0xFF1E3A5F).withValues(alpha: 0.1),
                    child: Icon(
                      isMobil ? Icons.directions_car : Icons.two_wheeler,
                      color: const Color(0xFF1E3A5F),
                    ),
                  ),
                  title: Text(kendaraan.nama,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${kendaraan.iconLabel} • ${kendaraan.platNomor}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RiwayatServisScreen(kendaraan: kendaraan),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
