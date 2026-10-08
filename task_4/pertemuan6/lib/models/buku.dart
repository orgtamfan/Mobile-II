class Buku {
  final String id;
  final String judul;
  final String penulis;
  final int tahun;
  final String sinopsis;
  bool favorit;
  bool dipinjam; 

  Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.tahun,
    required this.sinopsis,
    this.favorit = false,
    this.dipinjam = false,
  });
}