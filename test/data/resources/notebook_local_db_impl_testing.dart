import 'package:mockito/mockito.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';

class NotebookLocalDbImplTesting implements NotebookLocalDb  {
  final MoorDatabase _moorDatabase = MoorDatabase.testing();

  @override
  DbActions<Book> get book => _moorDatabase.bookDao;
  @override
  DbActions<Note> get note => _moorDatabase.noteDao;

  @override
  Future<void> dispose() async {
    await _moorDatabase.close();
  }
}