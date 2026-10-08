import 'package:flutter/material.dart';

class TidakDitemukanPage extends StatelessWidget {
  final String? nama;

  const TidakDitemukanPage({super.key, this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 12),
            Text('Rute ${nama ?? ''} tidak terdaftar'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}