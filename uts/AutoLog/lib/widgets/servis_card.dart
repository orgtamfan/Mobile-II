import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/servis_model.dart';

/// Kartu item untuk menampilkan ringkasan satu servis di halaman Riwayat Servis.
class ServisCard extends StatelessWidget {
  final ServisModel servis;
  final VoidCallback onTap;

  const ServisCard({super.key, required this.servis, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tanggalStr = DateFormat('dd MMM yyyy', 'id_ID').format(servis.tanggal);
    final biayaStr = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(servis.biaya);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: servis.fotoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          servis.fotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.build_circle_outlined,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                      )
                    : const Icon(Icons.build_circle_outlined,
                        color: Color(0xFF1E3A5F)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      servis.jenisServis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(tanggalStr,
                        style: TextStyle(
                            fontSize: 12.5, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Text(
                biayaStr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: Color(0xFF1E3A5F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
