import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HalamanA()));

class HalamanA extends StatelessWidget {
  const HalamanA({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman A')),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            // await: menunggu sampai Halaman B ditutup
            final hasil = await Navigator.push<String>(
              context,
              MaterialPageRoute(builder: (_) => const HalamanB()),
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hasil: ${hasil ?? "tidak ada"}')),
            );
          },
          child: const Text('Buka Halaman B'),
        ),
      ),
    );
  }
}

class HalamanB extends StatelessWidget {
  const HalamanB({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman B')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.pop(context, 'Dari Halaman B'),
              child: const Text('Kembali membawa hasil'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali tanpa hasil'),
            ),
          ],
        ),
      ),
    );
  }
}
