import 'package:flutter/material.dart';
import '../models/tugas.dart';
import '../utils/tanggal.dart';

class FormTugasPage extends StatefulWidget {
  final Tugas? tugas;

  const FormTugasPage({super.key, this.tugas});

  @override
  State<FormTugasPage> createState() => _FormTugasPageState();
}

class _FormTugasPageState extends State<FormTugasPage> {
  late TextEditingController _judulCtrl;
  late TextEditingController _matkulCtrl;
  late DateTime _tenggat;
  late Prioritas _prioritas;

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.tugas?.judul ?? '');
    _matkulCtrl = TextEditingController(text: widget.tugas?.matkul ?? '');
    _tenggat = widget.tugas?.tenggat ?? DateTime.now();
    _prioritas = widget.tugas?.prioritas ?? Prioritas.sedang;
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _matkulCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tenggat,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (hasil != null) {
      setState(() => _tenggat = hasil);
    }
  }

  void _simpan() {
    final judul = _judulCtrl.text.trim();
    final matkul = _matkulCtrl.text.trim();

    if (judul.isEmpty || matkul.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan matkul tidak boleh kosong')),
      );
      return;
    }

    final tugas = widget.tugas != null
        ? widget.tugas!.copyWith(
            judul: judul,
            matkul: matkul,
            tenggat: _tenggat,
            prioritas: _prioritas,
          )
        : Tugas(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            judul: judul,
            matkul: matkul,
            tenggat: _tenggat,
            prioritas: _prioritas,
          );

    Navigator.pop(context, tugas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tugas != null ? 'Ubah Tugas' : 'Tambah Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _judulCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _matkulCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Tenggat'),
                subtitle: Text(formatTanggal(_tenggat)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pilihTanggal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Prioritas>(
                value: _prioritas,
                decoration: const InputDecoration(
                  labelText: 'Prioritas',
                  border: OutlineInputBorder(),
                ),
                items: Prioritas.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(switch (p) {
                      Prioritas.rendah => 'Rendah',
                      Prioritas.sedang => 'Sedang',
                      Prioritas.tinggi => 'Tinggi',
                    }),
                  );
                }).toList(),
                onChanged: (nilai) {
                  if (nilai != null) {
                    setState(() => _prioritas = nilai);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _simpan,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
