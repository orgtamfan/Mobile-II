import 'package:flutter/material.dart';
import '../data/data_buku.dart';
import '../models/buku.dart';
import '../widgets/buku_tile.dart';

class DaftarBukuTab extends StatelessWidget {
  final void Function(Buku) onTapBuku;
  final void Function(Buku) onToggleFavorit;

  const DaftarBukuTab({
    super.key,
    required this.onTapBuku,
    required this.onToggleFavorit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataBuku.length,
      itemBuilder: (context, index) {
        final b = dataBuku[index];
        return BukuTile(
          buku: b,
          onTap: () => onTapBuku(b),
          onToggleFavorit: () => onToggleFavorit(b),
        );
      },
    );
  }
}