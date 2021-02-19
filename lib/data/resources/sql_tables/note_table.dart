import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/core/constants/constants.dart';

@DataClassName('Note')
class NoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book =>
      text().withLength(
        min: Constants.minBookTitleLength,
        max: Constants.maxBookTitleLength)();
  TextColumn get title =>
      text().withLength(
          min: Constants.minNoteTitleLength,
          max: Constants.maxNoteTitleLength)();
  DateTimeColumn get creationDate => dateTime().withDefault(Constant(DateTime.now()))();
  TextColumn get content => text()();
}