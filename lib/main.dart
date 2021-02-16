import 'package:flutter/material.dart';
import 'package:notebook/app.dart';
import 'package:notebook/injection/environment.dart';
import 'package:notebook/injection/injection.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(const App());
}

