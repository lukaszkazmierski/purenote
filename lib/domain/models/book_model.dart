import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';

class BookModel extends BookTableCompanion {
  BookModel({@required Value<String> name})
      : super(name: name);
}