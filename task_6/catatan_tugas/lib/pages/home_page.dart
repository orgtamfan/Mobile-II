import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tugas.dart';
import '../services/auth_service.dart';
import '../services/foto_service.dart';
import '../services/notifikasi_service.dart';
import '../services/profil_service.dart';
import '../services/tugas_service.dart';
import '../widgets/foto_base64.dart';
import 'form_page.dart';
import 'foto_page.dart';
import 'pengaturan_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TugasService _service = TugasService();
  final AuthService _auth = AuthService();

  Future<void> _konfirmasiKeluar(BuildContext context) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ya == true) {
      await NotifikasiService.hapusToken();
      await _auth.keluar();
    }
  }

  Future<void> _tampilkanToken(BuildContext context) async {
    final token = await NotifikasiService.ambilToken();
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Token FCM'),
        content: SelectableText(
          token ??
              'Token belum tersedia. Periksa izin notifikasi dan koneksi internet.',
        ),
        actions: [
          TextButton(
            onPressed: token == null
                ? null
                : () async {
                    await Clipboard.setData(ClipboardData(text: token));
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token disalin')),
                      );
                    }
                  },
            child: const Text('Salin'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _konfirmasiHapus(BuildContext context, Tugas t) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Yakin ingin menghapus "${t.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ya == true) {
      await _service.hapus(t.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tugas dihapus')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.penggunaSaatIni;
    final nama = user?.displayName ?? '';
    final sapaan = nama.isNotEmpty ? nama : (user?.email ?? 'Pengguna');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const PengaturanPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Token FCM',
            onPressed: () => _tampilkanToken(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () => _konfirmasiKeluar(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                StreamBuilder(
                  stream: ProfilService().perubahanProfil(),
                  builder: (context, snapshot) {
                    final kode =
                        snapshot.data?.data()?['fotoProfil'] as String?;
                    final bytes = FotoService.bacaKode(kode);
                    return CircleAvatar(
                      backgroundImage: bytes == null
                          ? null
                          : MemoryImage(bytes),
                      child: bytes == null
                          ? const Icon(Icons.person_outline)
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Halo, $sapaan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Tugas>>(
              stream: _service.semua(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return const Center(
                    child: Text('Belum ada tugas. Tekan untuk menambah.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final t = data[i];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          if (t.lampiranBase64?.isNotEmpty ?? false)
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => FotoPage(
                                    kode: t.lampiranBase64!,
                                    heroTag: 'foto-${t.id}',
                                  ),
                                ),
                              ),
                              child: Hero(
                                tag: 'foto-${t.id}',
                                child: SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: FotoBase64(kode: t.lampiranBase64!),
                                ),
                              ),
                            ),
                          ListTile(
                            leading: Checkbox(
                              value: t.selesai,
                              onChanged: (v) =>
                                  _service.setSelesai(t.id!, v ?? false),
                            ),
                            title: Text(
                              t.judul,
                              style: TextStyle(
                                decoration: t.selesai
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(t.mataKuliah),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FormPage(tugas: t),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _konfirmasiHapus(context, t),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
