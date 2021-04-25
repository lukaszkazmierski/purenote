import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';


class NotebookLocalDbImpl implements NotebookLocalDb  {
  final MoorDatabase _moorDatabase;

  NotebookLocalDbImpl(String pass) : _moorDatabase = MoorDatabase(pass);

  NotebookLocalDbImpl.testing() : _moorDatabase = MoorDatabase.testing();


  @override
  DbActions<Book> get book => _moorDatabase.bookDao;

  @override
  DbActions<Note> get note => _moorDatabase.noteDao;

  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> dbAsJson= {};

    final List<Book> books = await book.getAllItem();
    final List<Note> notes = await note.getAllItem();

    for(final Book gainedBook in books) {
      final String bookName = gainedBook.name;
      dbAsJson[bookName] = notes.where((x) => x.book == bookName).toList();
      notes.removeWhere((x) => x.book == bookName);
    }

    return dbAsJson;
  }

  @override
  Future<void> dispose() async {
    await _moorDatabase.close();
  }
}

