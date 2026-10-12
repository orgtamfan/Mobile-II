import 'package:flutter/material.dart';

// Tampilan pesan di tengah layar: kosong, tidak cocok, atau error
class StatePesan extends StatelessWidget {
  final IconData ikon;
  final String pesan;
  final String? labelTombol;
  final VoidCallback? onTombol;
  const StatePesan({
    super.key,
    required this.ikon,
    required this.pesan,
    this.labelTombol,
    this.onTombol,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(pesan, textAlign: TextAlign.center),
          if (onTombol != null) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onTombol,
              child: Text(labelTombol ?? 'Coba lagi'),
            ),
          ],
        ],
      ),
    );
  }
}
