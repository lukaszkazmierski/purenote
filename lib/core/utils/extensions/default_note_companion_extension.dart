import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';

extension DefaultNoteCompanion on NoteTableCompanion {
  NoteTableCompanion create({@required String bookName}) {
    return NoteTableCompanion(
      book: Value<String>(bookName),
      title: const Value<String>('New Note'),
      content: const Value<String>(''),
    );
  }
}