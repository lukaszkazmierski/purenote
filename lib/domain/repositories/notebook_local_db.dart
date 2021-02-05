
import 'package:moor/moor.dart';
import 'package:notebook/data/resources/moor_database.dart';

abstract class NotebookLocalDb {
  Future insertNote(Insertable<Note> note);
  Future updateNote(Insertable<Note> note);
  Future deleteNote(Insertable<Note> note);
}