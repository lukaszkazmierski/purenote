import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('Note')
class NoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book =>
      text().withLength(
        min: 1,
        max: 30)();
  TextColumn get title =>
      text().withLength(
          min: 1,
          max: 30)();
  DateTimeColumn get creationDate => dateTime().withDefault(Constant(DateTime.now()))();
  TextColumn get content => text()();
}