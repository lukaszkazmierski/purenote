import 'package:flutter/foundation.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';

class NoteModel extends NoteTableCompanion {
  NoteModel({@required Value<String> title, @required Value<String> content})
    : super(title: title, content: content);
}

