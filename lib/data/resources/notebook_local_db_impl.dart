import 'package:notebook/data/resources/daos/db_actions.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';

class NotebookLocalDbImpl implements NotebookLocalDb  {
  final MoorDatabase _moorDatabase = MoorDatabase();

  @override
  DbActions get book => _moorDatabase.bookDao;
  @override
  DbActions get note => _moorDatabase.noteDao;
}