import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/data/resources/sql_tables/note_table.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';


part 'note_dao.g.dart';

@UseDao(tables: [NoteTable])
class NoteDao extends DatabaseAccessor<MoorDatabase>
    with _$NoteDaoMixin implements DbActions<Note>  {

  final MoorDatabase db;

  NoteDao(this.db) : super(db);

  @override
  Future<List<Note>> getAllItem() => select(noteTable).get();
  @override
  Stream<List<Note>> watchAllItem([String bookName]) =>
      (select(noteTable)
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.creationDate, mode: OrderingMode.desc)
          ])
          ..where((tbl) => tbl.book.equals(bookName))
      ).watch();
  @override
  Future insertItem(Insertable<Note> note) => into(noteTable).insert(note);
  @override
  Future updateItem(Insertable<Note> note) => update(noteTable).replace(note);
  @override
  Future deleteItem(Insertable<Note> note) => delete(noteTable).delete(note);
}