import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';

export 'package:notebook/domain/repositories/notebook_local_db.dart';
export 'package:notebook/data/resources/moor_config/moor_database.dart' show Note;

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotebookLocalDb _notebookLocalDb;

  NoteBloc(this._notebookLocalDb) : super(NoteInitial());

  Future<List<Note>> get getAllNotes => _notebookLocalDb.note.getAllItem();
  Stream<List<Note>> watchAllNotes(String bookName) => _notebookLocalDb.note.watchAllItem(bookName);

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is AddingNewNote) {
      yield* _mapAddingNewNoteToState(event);
    } else if (event is RemoveNote) {
      yield* _mapRemoveNoteToState(event);
    }
  }

  Stream<NoteState> _mapAddingNewNoteToState(AddingNewNote event) async* {
    await _notebookLocalDb.note.insertItem(event.note);
    yield const NoteListUpdate();
  }

  Stream<NoteState> _mapRemoveNoteToState(RemoveNote event) async* {

  }

}
