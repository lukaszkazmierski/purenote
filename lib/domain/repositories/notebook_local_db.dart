import 'package:injectable/injectable.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart' show Book, Note;
import 'package:notebook/data/resources/daos/db_actions.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';

abstract class NotebookLocalDb {
  DbActions<Book> get book;
  DbActions<Note> get note;

  Future<void> dispose();
}