import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/core/constants/constants.dart';

@DataClassName('Book')
class BookTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(
          min: Constants.minBookTitleLength,
          max: Constants.maxBookTitleLength)();
}