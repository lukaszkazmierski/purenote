import 'package:flutter/material.dart';
import 'package:notebook/app.dart';
import 'package:notebook/core/secure/db_encryption.dart';
import 'package:notebook/service_locator//service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locator.register();
  locator.get<DbEncryption>().checkKey();
  runApp(const App());
}

