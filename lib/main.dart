import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kampus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const MenuPage(),
    );
  }
}

// Model Menu Item
class MenuItem {
  final String title;
  final IconData icon;
  final Widget page;
  MenuItem({required this.title, required this.icon, required this.page});
}

// Halaman Utama dengan GridView Menu
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  final List<MenuItem> menuList = [
    MenuItem(
      title: 'Registrasi',
      icon: Icons.assignment_ind,
      page: const RegistrasiPage(),
    ),
    MenuItem(title: 'Profil', icon: Icons.person, page: const ProfilPage()),
    MenuItem(
      title: 'Jadwal',
      icon: Icons.calendar_today,
      page: const JadwalPage(),
    ),
    MenuItem(title: 'Nilai', icon: Icons.grade, page: const NilaiPage()),
    MenuItem(title: 'KRS', icon: Icons.book, page: const MatkulPage()),
    MenuItem(
      title: 'Keuangan',
      icon: Icons.payment,
      page: const KeuanganPage(),
    ),
    MenuItem(
      title: 'Perpus',
      icon: Icons.local_library,
      page: const PerpusPage(),
    ),
    MenuItem(
      title: 'Pengumuman',
      icon: Icons.campaign,
      page: const PengumumanPage(),
    ),
    MenuItem(title: 'Bantuan', icon: Icons.help, page: const BantuanPage()),
  ];

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Utama')),
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
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.school, size: 60, color: Colors.white),
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
        children: [_buildGridMenu(), const NotifikasiPage(), const AkunPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Menu'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildGridMenu() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 18, color: Colors.indigo),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman MatkulPage (Digunakan untuk Menu KRS)
class MatkulPage extends StatelessWidget {
  const MatkulPage({super.key});

  static const List<String> _matkul = [
    'Mobile Programming',
    'Basis Data',
    'Jaringan Komputer',
    'Kecerdasan Buatan',
    'Rekayasa Perangkat Lunak',
    'Data Mining',
    'Keamanan Informasi',
    'Interaksi Manusia dan Komputer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mata Kuliah (KRS)')),
      body: ListView.separated(
        itemCount: _matkul.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(_matkul[index]),
            subtitle: const Text('3 SKS'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dipilih: ${_matkul[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}

class Mahasiswa {
  final String nama;
  final String npm;
  final String email;
  final String jenisKelamin;
  final String prodi;
  final DateTime tanggalLahir;
  final List<String> minat;
  final bool notifikasi;

  Mahasiswa({
    required this.nama,
    required this.npm,
    required this.email,
    required this.jenisKelamin,
    required this.prodi,
    required this.tanggalLahir,
    required this.minat,
    required this.notifikasi,
  });
}

// Helper Format Tanggal
String formatTanggal(DateTime d) {
  final hari = d.day.toString().padLeft(2, '0');
  final bulan = d.month.toString().padLeft(2, '0');
  return '$hari-$bulan-${d.year}';
}

// Halaman Form Registrasi Mahasiswa
class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _npmCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String _jenisKelamin = 'Laki-laki';
  String? _prodi;
  DateTime? _tanggalLahir;
  final Set<String> _minat = {};
  bool _notifikasi = true;
  bool _sembunyikanPassword = true;

  final List<String> _daftarProdi = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Rekayasa Perangkat Lunak',
  ];

  final List<String> _daftarMinat = [
    'Mobile Programming',
    'Web Development',
    'Data Science',
  ];

  @override
  void dispose() {
    _namaCtrl.dispose();
    _npmCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dekor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir belum dipilih')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Kirim data registrasi atas nama ${_namaCtrl.text}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _kirimData();
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  void _kirimData() {
    final data = Mahasiswa(
      nama: _namaCtrl.text.trim(),
      npm: _npmCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      jenisKelamin: _jenisKelamin,
      prodi: _prodi!,
      tanggalLahir: _tanggalLahir!,
      minat: _minat.toList(),
      notifikasi: _notifikasi,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil disimpan')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RingkasanPage(data: data)),
    );
  }

  void _reset() {
    _formKey.currentState?.reset();
    _namaCtrl.clear();
    _npmCtrl.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    setState(() {
      _jenisKelamin = 'Laki-laki';
      _prodi = null;
      _tanggalLahir = null;
      _minat.clear();
      _notifikasi = true;
      _sembunyikanPassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Mahasiswa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _namaCtrl,
              textInputAction: TextInputAction.next,
              decoration: _dekor('Nama Lengkap', Icons.person),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
                if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _npmCtrl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: _dekor('NPM', Icons.badge),
              validator: (v) {
                if (v == null || v.isEmpty) return 'NPM wajib diisi';
                if (v.length < 8) return 'NPM minimal 8 digit';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _dekor('Email', Icons.email),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                final pola = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
                if (!pola.hasMatch(v.trim())) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _sembunyikanPassword,
              decoration: _dekor('Password', Icons.lock).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _sembunyikanPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                    () => _sembunyikanPassword = !_sembunyikanPassword,
                  ),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password wajib diisi';
                if (v.length < 6) return 'Password minimal 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Jenis Kelamin',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Laki-laki',
                  label: Text('Laki-laki'),
                  icon: Icon(Icons.male),
                ),
                ButtonSegment(
                  value: 'Perempuan',
                  label: Text('Perempuan'),
                  icon: Icon(Icons.female),
                ),
              ],
              selected: {_jenisKelamin},
              onSelectionChanged: (s) =>
                  setState(() => _jenisKelamin = s.first),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _prodi,
              decoration: _dekor('Program Studi', Icons.school),
              items: _daftarProdi
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _prodi = v),
              validator: (v) => v == null ? 'Pilih program studi' : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                alignment: Alignment.centerLeft,
              ),
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _tanggalLahir == null
                    ? 'Pilih tanggal lahir'
                    : 'Tanggal lahir: ${formatTanggal(_tanggalLahir!)}',
              ),
            ),
            const SizedBox(height: 16),
            Text('Minat', style: Theme.of(context).textTheme.labelLarge),
            ..._daftarMinat.map(
              (m) => CheckboxListTile(
                title: Text(m),
                value: _minat.contains(m),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (dicentang) {
                  setState(() {
                    if (dicentang == true) {
                      _minat.add(m);
                    } else {
                      _minat.remove(m);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Terima notifikasi email'),
              contentPadding: EdgeInsets.zero,
              value: _notifikasi,
              onChanged: (v) => setState(() => _notifikasi = v),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                    label: const Text('Daftar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Ringkasan Data
class RingkasanPage extends StatelessWidget {
  final Mahasiswa data;

  const RingkasanPage({super.key, required this.data});

  Widget _baris(String label, String nilai) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        nilai,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Data')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.check_circle, size: 64, color: Colors.green),
          const SizedBox(height: 8),
          const Text(
            'Registrasi Berhasil',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _baris('Nama Lengkap', data.nama),
                const Divider(height: 1),
                _baris('NPM', data.npm),
                const Divider(height: 1),
                _baris('Email', data.email),
                const Divider(height: 1),
                _baris('Jenis Kelamin', data.jenisKelamin),
                const Divider(height: 1),
                _baris('Program Studi', data.prodi),
                const Divider(height: 1),
                _baris('Tanggal Lahir', formatTanggal(data.tanggalLahir)),
                const Divider(height: 1),
                _baris(
                  'Minat',
                  data.minat.isEmpty ? '-' : data.minat.join(', '),
                ),
                const Divider(height: 1),
                _baris('Notifikasi Email', data.notifikasi ? 'Ya' : 'Tidak'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali ke Form'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN-HALAMAN LAINNYA
// ==========================================

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.campaign),
          title: Text('Pembayaran SPP Dibuka'),
          subtitle: Text('12 Okt 2023'),
        ),
        ListTile(
          leading: Icon(Icons.warning),
          title: Text('Perbaikan Server SIAKAD'),
          subtitle: Text('10 Okt 2023'),
        ),
        ListTile(
          leading: Icon(Icons.event),
          title: Text('Jadwal UTS Semester Ganjil'),
          subtitle: Text('08 Okt 2023'),
        ),
        ListTile(
          leading: Icon(Icons.grade),
          title: Text('Nilai Mata Kuliah Diperbarui'),
          subtitle: Text('05 Okt 2023'),
        ),
        ListTile(
          leading: Icon(Icons.school),
          title: Text('Pendaftaran Wisuda'),
          subtitle: Text('01 Okt 2023'),
        ),
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

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Profil', icon: Icons.person);
  }
}

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Jadwal', icon: Icons.calendar_today);
  }
}

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Nilai', icon: Icons.grade);
  }
}

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Keuangan', icon: Icons.payment);
  }
}

class PerpusPage extends StatelessWidget {
  const PerpusPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Perpus', icon: Icons.local_library);
  }
}

class PengumumanPage extends StatelessWidget {
  const PengumumanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Pengumuman', icon: Icons.campaign);
  }
}

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _SimplePage(title: 'Bantuan', icon: Icons.help);
  }
}

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
            Text(
              'Ini adalah halaman $title',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
