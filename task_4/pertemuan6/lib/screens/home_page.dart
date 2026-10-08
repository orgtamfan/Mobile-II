import 'package:flutter/material.dart';
import '../data/data_buku.dart';
import '../models/buku.dart';
import '../routes/app_routes.dart';
import 'daftar_buku_tab.dart';
import 'favorit_tab.dart';
import 'profil_tab.dart';

class HomePage extends StatefulWidget {
  final String nama;

  const HomePage({super.key, required this.nama});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  Future<void> _bukaDetail(Buku b) async {
    final hasil = await Navigator.pushNamed<String>(
      context,
      AppRoutes.detail,
      arguments: b,
    );
    if (!mounted) return;
    setState(() {});
    if (hasil != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hasil)),
      );
    }
  }

  void _toggleFavorit(Buku b) => setState(() => b.favorit = !b.favorit);

  // Latihan 6: Menerima objek buku baru dan menambahkannya ke dataBuku
  Future<void> _tambahBuku() async {
    final bukuBaru = await Navigator.pushNamed<Buku>(context, AppRoutes.tambah);
    if (bukuBaru != null && mounted) {
      setState(() {
        dataBuku.add(bukuBaru);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Buku "${bukuBaru.judul}" berhasil ditambahkan')),
      );
    }
  }

  // Latihan 5: Dialog konfirmasi sebelum keluar
  Future<bool> _tanyaKeluar() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari aplikasi?'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
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
    const judul = ['Katalog Buku', 'Favorit', 'Profil'];

    // Latihan 5: Menahan tombol kembali sistem dengan PopScope
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final keluar = await _tanyaKeluar();
        if (keluar && context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(judul[_tab])),
        // Latihan 4: Menambahkan Drawer
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.nama),
                accountEmail: const Text('Anggota Perpustakaan'),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person, size: 40),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Tentang'),
                onTap: () {
                  Navigator.pop(context); // Tutup drawer dahulu
                  Navigator.pushNamed(context, AppRoutes.tentang);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Keluar'),
                onTap: () async {
                  Navigator.pop(context); // Tutup drawer dahulu
                  final yakin = await _tanyaKeluar();
                  if (yakin && context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _tab,
          children: [
            DaftarBukuTab(
              onTapBuku: _bukaDetail,
              onToggleFavorit: _toggleFavorit,
            ),
            FavoritTab(onTapBuku: _bukaDetail),
            ProfilTab(nama: widget.nama),
          ],
        ),
        // Latihan 6: Tombol Tambah Buku pada tab Katalog
        floatingActionButton: _tab == 0
            ? FloatingActionButton(
                onPressed: _tambahBuku,
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Katalog',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}