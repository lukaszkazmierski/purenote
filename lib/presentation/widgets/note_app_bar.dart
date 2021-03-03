import 'package:flutter/material.dart';

class NoteAppBar  {
  final String title;

  const NoteAppBar({this.title});

  AppBar call() =>
      AppBar(
        title: Text(title),
    );
  }
