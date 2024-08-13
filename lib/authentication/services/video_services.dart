import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class VideoService {


  VideoService();

  Future<File> downloadVideo(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<File> encryptFile(File file, String key) async {
    final keyBytes = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.allZerosOfLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
    final encrypted = encrypter.encryptBytes(await file.readAsBytes(), iv: iv);
    final encryptedFile = File('${file.path}.enc');
    await encryptedFile.writeAsBytes(encrypted.bytes);
    return encryptedFile;
  }

  Future<File> decryptFile(File file, String key) async {
    final keyBytes = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.allZerosOfLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
    final encryptedBytes = await file.readAsBytes();
    final decrypted =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
    final decryptedFile = File(file.path.replaceAll('.enc', ''));
    await decryptedFile.writeAsBytes(decrypted);
    return decryptedFile;
  }

  Future<File?> getLocalVideoFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    if (await file.exists()) {
      return file;
    }
    return null;
  }
}
