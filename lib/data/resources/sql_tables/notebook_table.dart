import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('Note')
class NoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 0, max: 30)();
  TextColumn get content => text()();
}