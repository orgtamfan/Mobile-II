import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class FotoService {
  static const int batasByte = 200 * 1024;
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pilih(ImageSource sumber) async {
    final file = await _picker.pickImage(
      source: sumber,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 60,
    );
    return file?.readAsBytes();
  }

  Future<Uint8List?> pilihFotoProfil() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 60,
    );
    return file?.readAsBytes();
  }

  static String kodekan(Uint8List data) => base64Encode(data);

  static Uint8List? bacaKode(String? kode) {
    if (kode == null || kode.isEmpty) return null;
    try {
      return base64Decode(kode);
    } on FormatException {
      return null;
    }
  }
}
