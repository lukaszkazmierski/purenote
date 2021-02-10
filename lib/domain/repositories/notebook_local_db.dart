import 'package:notebook/data/resources/daos/db_actions.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/models/book_model.dart';


abstract class NotebookLocalDb {
  DbActions<Book> get book;
  DbActions<Note> get note;
}