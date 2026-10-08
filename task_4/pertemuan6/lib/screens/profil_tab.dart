import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ProfilTab extends StatelessWidget {
  final String nama;

  const ProfilTab({super.key, required this.nama});

  Future<void> keluar(BuildContext context) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Anda akan kembali ke halaman login.'),
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

    if (yakin == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(nama),
          subtitle: const Text('Anggota perpustakaan'),
        ),
        const Divider(),
        // Latihan 1: Menu Tentang Aplikasi
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Aplikasi'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.tentang),
        ),
        ListTile(
          leading: const Icon(Icons.link_off),
          title: const Text('Coba rute tidak dikenal'),
          onTap: () => Navigator.pushNamed(context, '/rahasia'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Keluar'),
          onTap: () => keluar(context),
        ),
      ],
    );
  }
}