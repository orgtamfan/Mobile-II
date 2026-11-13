import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/kendaraan_model.dart';
import '../../models/servis_model.dart';
import '../../widgets/servis_card.dart';
import 'tambah_servis_screen.dart';
import 'detail_servis_screen.dart';

/// F-DATA-04: Riwayat servis per kendaraan, diurutkan dari yang terbaru.
class RiwayatServisScreen extends StatelessWidget {
  final KendaraanModel kendaraan;

  const RiwayatServisScreen({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text(kendaraan.nama),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TambahServisScreen(kendaraan: kendaraan),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Catat Servis'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A5F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  kendaraan.jenis == 'mobil'
                      ? Icons.directions_car
                      : Icons.two_wheeler,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kendaraan.nama,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    Text('${kendaraan.iconLabel} • ${kendaraan.platNomor}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.5)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Riwayat Servis',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: StreamBuilder<List<ServisModel>>(
              stream: firestoreService.streamServisByKendaraan(
                  uid, kendaraan.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Gagal memuat data: ${snapshot.error}'));
                }
                final list = snapshot.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Belum ada riwayat servis untuk kendaraan ini.\nKetuk "Catat Servis" untuk menambahkan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90, top: 4),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final servis = list[index];
                    return ServisCard(
                      servis: servis,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailServisScreen(servis: servis),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
