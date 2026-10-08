import 'package:flutter/material.dart';
import '../data/data_buku.dart';
import '../models/buku.dart';
import '../widgets/buku_tile.dart';

class FavoritTab extends StatelessWidget {
  final void Function(Buku) onTapBuku;

  const FavoritTab({super.key, required this.onTapBuku});

  @override
  Widget build(BuildContext context) {
    final favorit = dataBuku.where((b) => b.favorit).toList();
    if (favorit.isEmpty) {
      return const Center(child: Text('Belum ada buku favorit'));
    }
    return ListView.builder(
      itemCount: favorit.length,
      itemBuilder: (context, index) {
        final b = favorit[index];
        return BukuTile(buku: b, onTap: () => onTapBuku(b));
      },
    );
  }
}