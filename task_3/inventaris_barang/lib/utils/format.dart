/// Mengubah angka menjadi teks rupiah, mis. 8500000 -> Rp 8.500.000
String formatRupiah(num nilai) {
  final s = nilai.round().toString();
  final hasil = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    // sisipkan titik setiap tiga digit dari belakang
    if (i > 0 && (s.length - i) % 3 == 0) hasil.write('.');
    hasil.write(s[i]);
  }
  return 'Rp $hasil';
}