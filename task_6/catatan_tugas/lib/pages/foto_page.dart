import 'package:flutter/material.dart';

import '../services/foto_service.dart';

class FotoPage extends StatelessWidget {
  final String kode;
  final String heroTag;

  const FotoPage({super.key, required this.kode, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final bytes = FotoService.bacaKode(kode);
    return Scaffold(
      appBar: AppBar(title: const Text('Foto Lampiran')),
      body: Center(
        child: bytes == null
            ? const Icon(Icons.broken_image, size: 48)
            : InteractiveViewer(
                child: Hero(
                  tag: heroTag,
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
      ),
    );
  }
}
