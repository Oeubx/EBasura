import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String?> saveFilePlatform({
  required List<int> bytes,
  required String fileName,
  required String mimeType,
}) async {
  Directory? targetDir;
  if (Platform.isAndroid) {
    final downloadDir = Directory('/storage/emulated/0/Download');
    if (await downloadDir.exists()) {
      targetDir = downloadDir;
    } else {
      targetDir = await getExternalStorageDirectory();
    }
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    targetDir = await getDownloadsDirectory();
  }
  targetDir ??= await getApplicationDocumentsDirectory();

  final file = File('${targetDir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file.path;
}
