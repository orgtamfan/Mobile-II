import 'package:flutter/material.dart';
import '../models/tugas.dart';
import '../utils/tanggal.dart';

class TugasTile extends StatelessWidget {
  final Tugas tugas;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  const TugasTile({
    super.key,
    required this.tugas,
    required this.onToggle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final warna = switch (tugas.prioritas) {
      Prioritas.tinggi => Colors.red,
      Prioritas.sedang => Colors.orange,
      Prioritas.rendah => Colors.green,
    };
    final info =
        '${tugas.matkul} · ${formatTanggal(tugas.tenggat)}'
        '${tugas.terlambat ? ' · Terlambat' : ''}';
    return ListTile(
      // warna latar wajib agar tidak "tembus" saat digeser (Dismissible)
      tileColor: Theme.of(context).scaffoldBackgroundColor,
      leading: Checkbox(value: tugas.selesai, onChanged: (_) => onToggle()),
      title: Text(
        tugas.judul,
        style: TextStyle(
          decoration: tugas.selesai ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        info,
        style: tugas.terlambat ? const TextStyle(color: Colors.red) : null,
      ),
      trailing: Icon(Icons.flag, color: warna),
      onTap: onTap,
    );
  }
}
