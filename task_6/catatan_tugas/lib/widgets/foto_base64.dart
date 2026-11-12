import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/foto_service.dart';

class FotoBase64 extends StatefulWidget {
  final String kode;
  final BoxFit fit;

  const FotoBase64({super.key, required this.kode, this.fit = BoxFit.cover});

  @override
  State<FotoBase64> createState() => _FotoBase64State();
}

class _FotoBase64State extends State<FotoBase64> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = FotoService.bacaKode(widget.kode);
  }

  @override
  void didUpdateWidget(covariant FotoBase64 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kode != widget.kode) {
      _bytes = FotoService.bacaKode(widget.kode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes == null) {
      return const Center(child: Icon(Icons.broken_image, size: 40));
    }
    return Image.memory(
      bytes,
      width: double.infinity,
      fit: widget.fit,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.broken_image, size: 40)),
    );
  }
}
