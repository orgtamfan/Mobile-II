import 'package:flutter/material.dart';
import '../models/buku.dart';

class BukuTile extends StatelessWidget {
  final Buku buku;
  final VoidCallback onTap;
  final VoidCallback? onToggleFavorit;

  const BukuTile({
    super.key,
    required this.buku,
    required this.onTap,
    this.onToggleFavorit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(buku.judul[0])),
      title: Text(buku.judul),
      subtitle: Text(
        '${buku.penulis} ${buku.tahun}${buku.dipinjam ? ' • (Dipinjam)' : ''}',
      ),
      trailing: onToggleFavorit == null
          ? null
          : IconButton(
              onPressed: onToggleFavorit,
              icon: Icon(
                buku.favorit ? Icons.favorite : Icons.favorite_border,
                color: buku.favorit ? Colors.red : null,
              ),
            ),
      onTap: onTap,
    );
  }
}