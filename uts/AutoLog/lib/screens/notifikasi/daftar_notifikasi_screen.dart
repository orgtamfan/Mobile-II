import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/firestore_service.dart';
import '../../models/notifikasi_model.dart';

/// F-FCM-04: Daftar notifikasi yang pernah masuk ke aplikasi.
class DaftarNotifikasiScreen extends StatelessWidget {
  const DaftarNotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: StreamBuilder<List<NotifikasiModel>>(
        stream: firestoreService.streamNotifikasi(uid),
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_none,
                        size: 56, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text('Belum ada notifikasi',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notif = list[index];
              final tanggalStr =
                  DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(notif.tanggal);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: notif.sudahDibaca
                      ? Colors.grey.shade200
                      : const Color(0xFF1E3A5F).withValues(alpha: 0.1),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: notif.sudahDibaca
                        ? Colors.grey.shade500
                        : const Color(0xFF1E3A5F),
                  ),
                ),
                title: Text(
                  notif.judul,
                  style: TextStyle(
                      fontWeight:
                          notif.sudahDibaca ? FontWeight.normal : FontWeight.w600),
                ),
                subtitle: Text(notif.pesan),
                trailing: Text(tanggalStr,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                onTap: () {
                  if (!notif.sudahDibaca) {
                    firestoreService.tandaiNotifikasiDibaca(uid, notif.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
