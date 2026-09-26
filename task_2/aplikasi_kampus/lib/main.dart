import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kampus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MenuPage(),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final Widget page;
  MenuItem({required this.title, required this.icon, required this.page});
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  final List<MenuItem> menuList = [
    MenuItem(title: 'Profil', icon: Icons.person, page: const ProfilPage()),
    MenuItem(title: 'Jadwal', icon: Icons.calendar_today, page: const JadwalPage()),
    MenuItem(title: 'Nilai', icon: Icons.grade, page: const NilaiPage()),
    MenuItem(title: 'KRS', icon: Icons.book, page: const KrsPage()),
    MenuItem(title: 'Keuangan', icon: Icons.payment, page: const KeuanganPage()),
    MenuItem(title: 'Perpus', icon: Icons.local_library, page: const PerpusPage()),
    MenuItem(title: 'Pengumuman', icon: Icons.campaign, page: const PengumumanPage()),
    MenuItem(title: 'Bantuan', icon: Icons.help, page: const BantuanPage()),
  ];

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aplikasi Kampus',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Aplikasi Kampus',
                  applicationVersion: '1.0.0',
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildGridMenu(),
          const NotifikasiPage(),
          const AkunPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildGridMenu() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: menuList.length,
      itemBuilder: (context, index) {
        final item = menuList[index];
        return _buildMenuCard(context, item);
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 36, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(item.title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(leading: Icon(Icons.campaign), title: Text('Pembayaran SPP Dibuka'), subtitle: Text('12 Okt 2023')),
        ListTile(leading: Icon(Icons.warning), title: Text('Perbaikan Server SIAKAD'), subtitle: Text('10 Okt 2023')),
        ListTile(leading: Icon(Icons.event), title: Text('Jadwal UTS Semester Ganjil'), subtitle: Text('08 Okt 2023')),
        ListTile(leading: Icon(Icons.grade), title: Text('Nilai Mata Kuliah Diperbarui'), subtitle: Text('05 Okt 2023')),
        ListTile(leading: Icon(Icons.school), title: Text('Pendaftaran Wisuda'), subtitle: Text('01 Okt 2023')),
      ],
    );
  }
}

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Halaman Pengaturan Akun', style: TextStyle(fontSize: 18)),
    );
  }
}

class ProfilPage extends StatelessWidget { const ProfilPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Profil', icon: Icons.person); } }
class JadwalPage extends StatelessWidget { const JadwalPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Jadwal', icon: Icons.calendar_today); } }
class NilaiPage extends StatelessWidget { const NilaiPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Nilai', icon: Icons.grade); } }
class KrsPage extends StatelessWidget { const KrsPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'KRS', icon: Icons.book); } }
class KeuanganPage extends StatelessWidget { const KeuanganPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Keuangan', icon: Icons.payment); } }
class PerpusPage extends StatelessWidget { const PerpusPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Perpus', icon: Icons.local_library); } }
class PengumumanPage extends StatelessWidget { const PengumumanPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Pengumuman', icon: Icons.campaign); } }
class BantuanPage extends StatelessWidget { const BantuanPage({super.key}); @override Widget build(BuildContext context) { return const _SimplePage(title: 'Bantuan', icon: Icons.help); } }

class _SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SimplePage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.indigo),
            const SizedBox(height: 12),
            Text('Ini adalah halaman $title', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}