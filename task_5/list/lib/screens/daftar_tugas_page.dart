import 'package:flutter/material.dart';
import '../data/tugas_repository.dart';
import '../models/tugas.dart';
import '../routes/app_routes.dart';
import '../widgets/state_pesan.dart';
import '../widgets/tugas_tile.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  final _repo = TugasRepository();
  late Future<List<Tugas>> _daftar;
  int _limitTampil = 10;
  bool _kisi = false;
  bool _manualOrder = false;
  List<Tugas>? _terhapus = [];

  @override
  void initState() {
    super.initState();
    _muat();
  }

  void _muat() {
    setState(() {
      _daftar = _repo.muat();
    });
  }

  Future<void> _tambah() async {
    final hasil = await Navigator.pushNamed<Tugas>(context, AppRoutes.form);
    if (hasil != null) {
      final daftar = await _daftar;
      daftar.add(hasil);
      await _repo.simpan(daftar);
      _muat();
    }
  }

  Future<void> _ubah(Tugas tugas) async {
    final hasil = await Navigator.pushNamed<Tugas>(
      context,
      AppRoutes.form,
      arguments: tugas,
    );
    if (hasil != null) {
      final daftar = await _daftar;
      final indeks = daftar.indexWhere((t) => t.id == tugas.id);
      if (indeks >= 0) {
        daftar[indeks] = hasil;
        await _repo.simpan(daftar);
        _muat();
      }
    }
  }

  Future<void> _toggle(Tugas tugas) async {
    final daftar = await _daftar;
    final indeks = daftar.indexWhere((t) => t.id == tugas.id);
    if (indeks >= 0) {
      daftar[indeks] = tugas.copyWith(selesai: !tugas.selesai);
      await _repo.simpan(daftar);
      _muat();
    }
  }

  Future<void> _hapus(Tugas tugas) async {
    final daftar = await _daftar;
    daftar.removeWhere((t) => t.id == tugas.id);
    await _repo.simpan(daftar);
    _muat();
  }

  Future<void> _hapusSelesai() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas Selesai?'),
        content: const Text('Semua tugas yang sudah selesai akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final daftar = await _daftar;
      _terhapus = daftar.where((t) => t.selesai).toList();
      daftar.removeWhere((t) => t.selesai);
      await _repo.simpan(daftar);
      _muat();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_terhapus?.length} tugas dihapus'),
            action: SnackBarAction(
              label: 'Urungkan',
              onPressed: () async {
                final daftar2 = await _daftar;
                daftar2.addAll(_terhapus ?? []);
                await _repo.simpan(daftar2);
                _muat();
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _buatContoh() async {
    final daftar = await _daftar;
    final sebelum = daftar.length;
    daftar.addAll(_repo.buatContohBag2(sebelum));
    await _repo.simpan(daftar);
    setState(() => _limitTampil = 10);
    _muat();
  }

  void _muatLagi() {
    setState(() => _limitTampil += 10);
  }

  Future<void> _simpanUrutanManual(List<Tugas> daftar) async {
    await _repo.simpan(daftar);
  }

  // Latihan 5: Dialog konfirmasi sebelum keluar
  Future<bool> _tanyaKeluar() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari aplikasi?'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
    return yakin ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Latihan 5: Menahan tombol kembali sistem dengan PopScope
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final ok = await _tanyaKeluar();
          if (context.mounted && ok) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Tugas'),
          actions: [
            IconButton(
              icon: Icon(_kisi ? Icons.menu : Icons.grid_3x3),
              onPressed: () => setState(() => _kisi = !_kisi),
              tooltip: 'Toggle tampilan',
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => _manualOrder = value == 'manual');
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'manual',
                  child: Text(
                    'Urutan Manual',
                    style: TextStyle(
                      fontWeight: _manualOrder ? FontWeight.bold : null,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'normal',
                  child: Text(
                    'Urutan Normal',
                    style: TextStyle(
                      fontWeight: !_manualOrder ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _hapusSelesai,
              tooltip: 'Hapus selesai',
            ),
            IconButton(
              icon: const Icon(Icons.library_add),
              onPressed: _buatContoh,
              tooltip: 'Buat 40 contoh',
            ),
          ],
        ),
        body: FutureBuilder<List<Tugas>>(
          future: _daftar,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return StatePesan(
                ikon: Icons.error,
                pesan: 'Terjadi kesalahan: ${snapshot.error}',
                labelTombol: 'Coba lagi',
                onTombol: _muat,
              );
            }

            final semua = snapshot.data ?? [];
            if (semua.isEmpty) {
              return StatePesan(
                ikon: Icons.check_circle,
                pesan: 'Tidak ada tugas',
                labelTombol: 'Tambah tugas',
                onTombol: _tambah,
              );
            }

            final aktif = semua.where((t) => !t.selesai).length;
            final selesai = semua.where((t) => t.selesai).length;
            final terlambat = semua.where((t) => t.terlambat).length;

            final tampil = semua.take(_limitTampil).toList();
            final lebihBanyak = semua.length > _limitTampil;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statItem('Aktif', aktif.toString(), Colors.blue),
                          _statItem(
                            'Selesai',
                            selesai.toString(),
                            Colors.green,
                          ),
                          _statItem(
                            'Terlambat',
                            terlambat.toString(),
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _manualOrder
                      ? ReorderableListView.builder(
                          itemCount: tampil.length + (lebihBanyak ? 1 : 0),
                          onReorder: (oldIndex, newIndex) async {
                            if (oldIndex < tampil.length &&
                                newIndex < tampil.length) {
                              if (oldIndex < newIndex) newIndex--;
                              final item = tampil.removeAt(oldIndex);
                              tampil.insert(newIndex, item);
                              await _simpanUrutanManual(semua);
                            }
                          },
                          itemBuilder: (context, indeks) {
                            if (indeks >= tampil.length) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                key: const ValueKey('load-more'),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: _muatLagi,
                                    child: const Text('Muat lagi'),
                                  ),
                                ),
                              );
                            }
                            final tugas = tampil[indeks];
                            return _buildTile(tugas, key: ValueKey(tugas.id));
                          },
                        )
                      : (_kisi
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                    ),
                                itemCount:
                                    tampil.length + (lebihBanyak ? 1 : 0),
                                itemBuilder: (context, indeks) {
                                  if (indeks >= tampil.length) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: FilledButton(
                                        onPressed: _muatLagi,
                                        child: const Text('Muat lagi'),
                                      ),
                                    );
                                  }
                                  final tugas = tampil[indeks];
                                  return _buildTile(tugas);
                                },
                              )
                            : ListView.builder(
                                itemCount:
                                    tampil.length + (lebihBanyak ? 1 : 0),
                                itemBuilder: (context, indeks) {
                                  if (indeks >= tampil.length) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: FilledButton(
                                          onPressed: _muatLagi,
                                          child: const Text('Muat lagi'),
                                        ),
                                      ),
                                    );
                                  }
                                  final tugas = tampil[indeks];
                                  return _buildTile(tugas);
                                },
                              )),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _tambah,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _statItem(String label, String nilai, Color color) {
    return Column(
      children: [
        Text(
          nilai,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildTile(Tugas tugas, {Key? key}) {
    return Dismissible(
      key: key ?? ValueKey(tugas.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _hapus(tugas);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await _toggle(tugas);
          return false;
        }
        return true;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      child: TugasTile(
        tugas: tugas,
        onToggle: () => _toggle(tugas),
        onTap: () => _ubah(tugas),
      ),
    );
  }
}
