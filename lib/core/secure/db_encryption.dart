import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DbEncryption {
  final Random _rnd = Random.secure();
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567'
      '890`~!@#\$%^&*()_+-=[]{};\':\\"|,./<>?/"';
  final String _dbStoragePassKey = 'dbMoorPass';
  final _storage = const FlutterSecureStorage();

  Future<String> get getDbPassword async => _storage.read(key: _dbStoragePassKey);

  Future<void> setDbPassword(String secret) async =>
      _storage.write(key: _dbStoragePassKey, value: secret);

  Future<void> checkKey() async {
    final pass = await getDbPassword;
    if (pass == null) {
      final secret = getRandString(20);
      await setDbPassword(secret);
    }
  }

  String getRandString(int len) => String.fromCharCodes(Iterable.generate(
      len, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}
