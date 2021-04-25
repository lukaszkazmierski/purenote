import 'package:notebook/data/resources/moor_config/moor_database.dart' show Book, Note;
import 'package:notebook/data/resources/daos/db_actions.dart';


abstract class NotebookLocalDb {
  DbActions<Book> get book;
  DbActions<Note> get note;

  Future<Map<String, dynamic>> toJson();

  Future<void> dispose();
}