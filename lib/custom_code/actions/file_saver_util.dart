import 'file_saver_stub.dart'
    if (dart.library.html) 'file_saver_web.dart'
    if (dart.library.io) 'file_saver_io.dart';

Future<String?> saveExportedFile({
  required List<int> bytes,
  required String fileName,
  required String mimeType,
}) =>
    saveFilePlatform(
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
    );
