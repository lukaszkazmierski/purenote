import 'package:flutter/material.dart';
import 'package:notebook/app.dart';
import 'package:notebook/service_locator//service_locator.dart';

void main() {
  locator.register();
  runApp(const App());
}

