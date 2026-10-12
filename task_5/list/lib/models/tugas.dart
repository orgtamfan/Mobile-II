enum Prioritas { rendah, sedang, tinggi }

class Tugas {
  final String id;
  final String judul;
  final String matkul;
  final DateTime tenggat;
  final Prioritas prioritas;
  final bool selesai;
  const Tugas({
    required this.id,
    required this.judul,
    required this.matkul,
    required this.tenggat,
    this.prioritas = Prioritas.sedang,
    this.selesai = false,
  });
  // terlambat: belum selesai dan tanggal tenggat sudah lewat (bandingkan tanggal)
  bool get terlambat {
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    return !selesai && tenggat.isBefore(hariIni);
  }

  Tugas copyWith({
    String? judul,
    String? matkul,
    DateTime? tenggat,
    Prioritas? prioritas,
    bool? selesai,
  }) {
    return Tugas(
      id: id,
      judul: judul ?? this.judul,
      matkul: matkul ?? this.matkul,
      tenggat: tenggat ?? this.tenggat,
      prioritas: prioritas ?? this.prioritas,
      selesai: selesai ?? this.selesai,
    );
  }

  // objek -> Map (siap diubah menjadi JSON)
  Map<String, dynamic> toMap() => {
    'id': id,
    'judul': judul,
    'matkul': matkul,
    'tenggat': tenggat.toIso8601String(),
    'prioritas': prioritas.name,
    'selesai': selesai,
  };
  // Map -> objek
  factory Tugas.fromMap(Map<String, dynamic> map) {
    return Tugas(
      id: map['id'] as String,
      judul: map['judul'] as String,
      matkul: map['matkul'] as String,
      tenggat: DateTime.parse(map['tenggat'] as String),
      prioritas: Prioritas.values.byName(map['prioritas'] as String),
      selesai: map['selesai'] as bool,
    );
  }
}
