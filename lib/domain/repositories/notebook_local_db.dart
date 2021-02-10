import 'package:notebook/data/resources/daos/db_actions.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';



abstract class NotebookLocalDb {
  DbActions<Book> get book;
  DbActions<Note> get note;
}