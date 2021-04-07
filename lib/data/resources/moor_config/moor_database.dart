import 'package:moor_flutter/moor_flutter.dart';
import 'package:encrypted_moor/encrypted_moor.dart';
import 'package:moor/ffi.dart';

import 'package:notebook/data/resources/sql_tables/book_table.dart';
import 'package:notebook/data/resources/sql_tables/note_table.dart';

import 'package:notebook/data/resources/daos/book_dao.dart';
import 'package:notebook/data/resources/daos/note_dao.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [NoteTable, BookTable], daos: [NoteDao, BookDao])
class MoorDatabase extends _$MoorDatabase {
  MoorDatabase(String pass) : super(EncryptedExecutor.inDatabaseFolder(
      path: 'db.sqlite', password: pass));

  MoorDatabase.testing() : super(VmDatabase.memory());

  @override
  int get schemaVersion => 1;
}