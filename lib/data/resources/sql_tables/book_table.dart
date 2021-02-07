import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('Book')
class BookTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30)();
}