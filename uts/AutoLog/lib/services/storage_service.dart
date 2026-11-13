import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Service untuk Firebase Storage.
/// Menangani upload, progress, dan hapus foto nota servis.
/// Path penyimpanan: nota_servis/{uid}/{servisId}.jpg
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Kompres gambar sebelum upload agar lebih cepat (sesuai mitigasi risiko di PRD).
  Future<File> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1080,
        minHeight: 1080,
      );

      if (result != null) {
        return File(result.path);
      }
      return file;
    } catch (_) {
      // Jika kompresi gagal, pakai file asli agar upload tetap berjalan.
      return file;
    }
  }

  /// Upload foto nota servis dengan progress callback (0.0 - 1.0).
  /// Mengembalikan map berisi downloadUrl dan storagePath.
  Future<Map<String, String>> uploadFotoNota({
    required String uid,
    required String servisId,
    required File file,
    required void Function(double progress) onProgress,
  }) async {
    final compressed = await _compressImage(file);
    final path = 'nota_servis/$uid/$servisId.jpg';
    final ref = _storage.ref().child(path);

    final uploadTask = ref.putFile(
      compressed,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    uploadTask.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      }
    });

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return {
      'fotoUrl': downloadUrl,
      'fotoPath': path,
    };
  }

  /// Hapus foto dari Firebase Storage berdasarkan path-nya.
  Future<void> hapusFoto(String fotoPath) async {
    try {
      await _storage.ref().child(fotoPath).delete();
    } on FirebaseException catch (e) {
      // Jika file sudah tidak ada, abaikan agar tidak crash.
      if (e.code != 'object-not-found') {
        rethrow;
      }
    }
  }
}
