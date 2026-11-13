import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../models/kendaraan_model.dart';
import '../kendaraan/tambah_kendaraan_screen.dart';
import '../servis/riwayat_servis_screen.dart';
import '../notifikasi/daftar_notifikasi_screen.dart';
import '../profil/profil_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firestoreService = FirestoreService();
    final uid = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoLog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifikasi',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const DaftarNotifikasiScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profil',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TambahKendaraanScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Kendaraan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Halo, ${user?.email?.split('@').first ?? 'Pengguna'} 👋',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Kendaraan Anda',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<KendaraanModel>>(
              stream: firestoreService.streamKendaraan(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat data: ${snapshot.error}'),
                  );
                }
                final kendaraanList = snapshot.data ?? [];
                if (kendaraanList.isEmpty) {
                  return _EmptyState(onTambah: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TambahKendaraanScreen()),
                    );
                  });
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: kendaraanList.length,
                  itemBuilder: (context, index) {
                    final kendaraan = kendaraanList[index];
                    return _KendaraanTile(kendaraan: kendaraan);
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

class _KendaraanTile extends StatelessWidget {
  final KendaraanModel kendaraan;

  const _KendaraanTile({required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    final isMobil = kendaraan.jenis == 'mobil';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A5F).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
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
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onTambah;

  const _EmptyState({required this.onTambah});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Belum ada kendaraan',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan kendaraan pertama Anda untuk mulai mencatat servis.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onTambah,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kendaraan'),
            ),
          ],
        ),
      ),
    );
  }
}
