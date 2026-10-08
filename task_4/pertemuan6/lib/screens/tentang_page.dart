import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, size: 80, color: Colors.teal),
            SizedBox(height: 16),
            Text(
              'Katalog Buku',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versi 1.0.0', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text('Aplikasi katalog perpustakaan berbasis Flutter.'),
          ],
        ),
      ),
    );
  }
}