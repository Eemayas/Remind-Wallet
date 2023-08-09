// ignore_for_file: avoid_print
import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class EncryptionHelper {
  // Generate a 32-byte (256-bit) random secret key
  static String secretKey = Key.fromSecureRandom(16).base64;
  static final key = Key.fromUtf8(secretKey); // Change this to your own secret key
  static final iv = IV.fromLength(16); // Initialization vector

  static String encryptList(List<Map<String, dynamic>> data) {
    final encrypter = Encrypter(AES(key));

    final encryptedData = data.map((map) {
      final jsonString = json.encode(map);
      final encrypted = encrypter.encrypt(jsonString, iv: iv);
      return encrypted.base64;
    }).toList();

    return json.encode(encryptedData);
  }

  static List<Map<String, dynamic>> decryptList(String encryptedData) {
    final encrypter = Encrypter(AES(key));

    final encryptedList = json.decode(encryptedData);
    final decryptedData = encryptedList.map<Map<String, dynamic>>((encryptedItem) {
      final encrypted = Encrypted.fromBase64(encryptedItem);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return json.decode(decrypted);
    }).toList();

    return decryptedData;
  }

  static String encryptMap(Map<String, dynamic> data) {
    final encrypter = Encrypter(AES(key));

    final jsonString = json.encode(data);
    final encrypted = encrypter.encrypt(jsonString, iv: iv);

    return encrypted.base64;
  }

  static Map<String, dynamic> decryptMap(String encryptedData) {
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.fromBase64(encryptedData);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return json.decode(decrypted);
  }
}

// void main() {
//   List<Map<String, dynamic>> originalList = [
//     {'name': 'Alice', 'age': 25},
//     {'name': 'Bob', 'age': 30},
//   ];

//   String encryptedListData = EncryptionHelper.encryptList(originalList);
//   List<Map<String, dynamic>> decryptedList = EncryptionHelper.decryptList(encryptedListData);

//   print('Original List: $originalList');
//   print('Encrypted Data: $encryptedListData');
//   print('Decrypted List: $decryptedList');

//   Map<String, dynamic> originalMap = {
//     'name': 'Alice',
//     'age': 25,
//   };

//   String encryptedMapData = EncryptionHelper.encryptMap(originalMap);
//   Map<String, dynamic> decryptedMap = EncryptionHelper.decryptMap(encryptedMapData);

//   print('Original Map: $originalMap');
//   print('Encrypted Data: $encryptedMapData');
//   print('Decrypted Map: $decryptedMap');
// }
