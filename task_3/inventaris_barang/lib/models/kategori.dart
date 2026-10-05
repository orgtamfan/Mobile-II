/// Enum yang diperluas (enhanced enum): setiap nilai membawa label tampilan.
enum Kategori {
  elektronik('Elektronik'),
  atk('ATK'),
  perabot('Perabot');

  final String label;
  const Kategori(this.label);
}