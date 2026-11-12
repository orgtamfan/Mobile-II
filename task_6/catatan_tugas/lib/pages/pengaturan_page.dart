import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/foto_service.dart';
import '../services/notifikasi_service.dart';
import '../services/profil_service.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final _profil = ProfilService();
  bool _memuatPreferensi = true;
  bool _notifikasiAktif = true;
  bool _menyimpanFoto = false;
  Uint8List? _fotoBaru;

  @override
  void initState() {
    super.initState();
    _muatPreferensi();
  }

  Future<void> _muatPreferensi() async {
    try {
      final aktif = await NotifikasiService.ambilPreferensiNotifikasi();
      if (mounted) {
        setState(() {
          _notifikasiAktif = aktif;
          _memuatPreferensi = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _memuatPreferensi = false);
        _pesan('Gagal membaca pengaturan: $error');
      }
    }
  }

  void _pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  Future<void> _aturNotifikasi(bool aktif) async {
    setState(() => _notifikasiAktif = aktif);
    try {
      await NotifikasiService.aturNotifikasiAktif(aktif);
      _pesan(
        aktif
            ? 'Berlangganan topik pengumuman.'
            : 'Langganan topik pengumuman dihentikan.',
      );
    } catch (error) {
      if (mounted) setState(() => _notifikasiAktif = !aktif);
      _pesan('Gagal menyimpan pengaturan: $error');
    }
  }

  Future<void> _pilihFoto() async {
    try {
      final foto = await _profil.pilihFotoProfil();
      if (!mounted || foto == null) return;
      setState(() => _fotoBaru = foto);
    } catch (error) {
      _pesan('Gagal memilih foto profil: $error');
    }
  }

  Future<void> _simpanFoto() async {
    final foto = _fotoBaru;
    if (foto == null) return;
    setState(() => _menyimpanFoto = true);
    try {
      await _profil.simpanFotoProfil(foto);
      if (mounted) setState(() => _fotoBaru = null);
      _pesan('Foto profil disimpan.');
    } catch (error) {
      _pesan('Gagal menyimpan foto profil: $error');
    } finally {
      if (mounted) setState(() => _menyimpanFoto = false);
    }
  }

  Future<void> _hapusFoto() async {
    try {
      await _profil.hapusFotoProfil();
      if (mounted) setState(() => _fotoBaru = null);
      _pesan('Foto profil dihapus.');
    } catch (error) {
      _pesan('Gagal menghapus foto profil: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notifikasi pengumuman'),
            subtitle: const Text('Berlangganan topik FCM pengumuman'),
            value: _notifikasiAktif,
            onChanged: _memuatPreferensi ? null : _aturNotifikasi,
          ),
          const Divider(height: 32),
          Text('Foto Profil', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Center(
            child: StreamBuilder(
              stream: _profil.perubahanProfil(),
              builder: (context, snapshot) {
                final kode = snapshot.data?.data()?['fotoProfil'] as String?;
                final bytes = _fotoBaru ?? FotoService.bacaKode(kode);
                return CircleAvatar(
                  radius: 56,
                  backgroundImage: bytes == null ? null : MemoryImage(bytes),
                  child: bytes == null
                      ? const Icon(Icons.person, size: 48)
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _menyimpanFoto ? null : _pilihFoto,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Pilih Foto Profil'),
          ),
          if (_fotoBaru != null) ...[
            FilledButton(
              onPressed: _menyimpanFoto ? null : _simpanFoto,
              child: _menyimpanFoto
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('SIMPAN FOTO'),
            ),
            TextButton(
              onPressed: _menyimpanFoto
                  ? null
                  : () => setState(() => _fotoBaru = null),
              child: const Text('Batalkan pilihan'),
            ),
          ] else
            TextButton.icon(
              onPressed: _hapusFoto,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus Foto Profil'),
            ),
        ],
      ),
    );
  }
}
