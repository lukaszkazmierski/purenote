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
  final NotebookLocalDb notebookLocalDb;

  NoteBloc({@required this.notebookLocalDb}) : super(const NoteInitial());

  Future<List<Note>> get getAllNotes => notebookLocalDb.note.getAllItem();
  Stream<List<Note>> watchAllNotes(String bookName) => notebookLocalDb.note.watchAllItem(bookName);

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is AddingNewNote) {
      await notebookLocalDb.note.insertItem(event.note);
      yield* _mapAddingNewNoteToState(event);
    } else if (event is RemoveNote) {
      yield* _mapRemoveNoteToState(event);
    } else if (event is UpdateNote) {
      yield* _mapUpdateNoteToState(event);
    }
  }

  Stream<NoteState> _mapAddingNewNoteToState(AddingNewNote event) async* {
    await notebookLocalDb.note.insertItem(event.note);
    yield const NoteListUpdate();
  }

  Stream<NoteState> _mapRemoveNoteToState(RemoveNote event) async* {
    await notebookLocalDb.note.deleteItem(event.note);
    yield const NoteListUpdate();
  }

  Stream<NoteState> _mapUpdateNoteToState(UpdateNote event) async* {
    await notebookLocalDb.note.updateItem(event.note);
    yield const NoteUpdated();
  }
}
