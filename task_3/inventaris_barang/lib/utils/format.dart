/// Extension pada num untuk mengubah angka ke format rupiah (misal: 8500000.rupiah)
extension RupiahX on num {
  String get rupiah {
    final s = round().toString();
    final hasil = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) hasil.write('.');
      hasil.write(s[i]);
    }
    return 'Rp $hasil';
  }
}

// Fungsi bantu untuk menjaga kompatibilitas kode sebelumnya
String formatRupiah(num nilai) => nilai.rupiah;