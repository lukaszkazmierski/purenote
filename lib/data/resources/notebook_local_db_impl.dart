import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';


class NotebookLocalDbImpl implements NotebookLocalDb  {
  final MoorDatabase _moorDatabase;

  NotebookLocalDbImpl() : _moorDatabase = MoorDatabase();

  NotebookLocalDbImpl.testing() : _moorDatabase = MoorDatabase.testing();


  @override
  DbActions<Book> get book => _moorDatabase.bookDao;
  @override
  DbActions<Note> get note => _moorDatabase.noteDao;

  @override
  Future<void> dispose() async {
    await _moorDatabase.close();
  }
}

