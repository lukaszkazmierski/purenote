import 'package:flutter/material.dart';
import 'package:notebook/app.dart';
import 'package:notebook/service_locator//service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locator.register();
  runApp(const App());
}

