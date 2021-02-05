import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';
import 'package:notebook/data/resources/sql_tables/notebook_table.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [NoteTable], daos: [NotebookLocalDbImpl])
class MoorDatabase extends _$MoorDatabase {
  MoorDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(
      path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}