import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/data/resources/moor_database.dart';
import 'package:notebook/data/resources/sql_tables/notebook_table.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';

part 'notebook_local_db_impl.g.dart';

@UseDao(tables: [NoteTable])
class NotebookLocalDbImpl extends DatabaseAccessor<MoorDatabase>
    with _$NotebookLocalDbImplMixin implements NotebookLocalDb  {

  final MoorDatabase db;

  NotebookLocalDbImpl(this.db) : super(db);

  Future insertNote(Insertable<Note> note) => into(noteTable).insert(note);
  Future updateNote(Insertable<Note> note) => update(noteTable).replace(note);
  Future deleteNote(Insertable<Note> note) => delete(noteTable).delete(note);
}