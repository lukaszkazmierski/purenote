/*import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/data/resources/sql_tables/book_table.dart';
import 'package:notebook/data/resources/sql_tables/note_table.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
*/
//part 'notebook_local_db_impl.g.dart';
/*
@UseDao(tables: [NoteTable, BookTable])
class NotebookLocalDbImpl extends DatabaseAccessor<MoorDatabase>
    with _$NotebookLocalDbImplMixin implements NotebookLocalDb  {

  final MoorDatabase db;

  NotebookLocalDbImpl(this.db) : super(db);

  @override
  Future<List<Note>> getAllNotes() => select(noteTable).get();
  @override
  Stream<List<Note>> watchAllNotes() => select(noteTable).watch();
  @override
  Future insertNote(Insertable<Note> note) => into(noteTable).insert(note);
  @override
  Future updateNote(Insertable<Note> note) => update(noteTable).replace(note);
  @override
  Future deleteNote(Insertable<Note> note) => delete(noteTable).delete(note);
}*/