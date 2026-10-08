mixin Diskon {
  double get persenDiskon;

  double hargaSetelahDiskon(double harga) {
    if (persenDiskon <= 0) return harga;
    return harga - (harga * (persenDiskon / 100));
  }
}