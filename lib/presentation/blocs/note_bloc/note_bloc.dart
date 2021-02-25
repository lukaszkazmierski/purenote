import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notebook/core/exceptions/exception_code.dart';
import 'package:notebook/core/exceptions/exception_code_translator.dart';
import 'package:notebook/core/exceptions/failure.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import 'package:notebook/service_locator/service_locator.dart';

export 'package:notebook/domain/repositories/notebook_local_db.dart';
export 'package:notebook/data/resources/moor_config/moor_database.dart' show Note;

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotebookLocalDb notebookLocalDb;
  final ExceptionCode _exceptionCode = locator.get<ExceptionCode>();
  final ExceptionCodeTranslator _codeTranslator =
    locator.get<ExceptionCodeTranslator>();
  NoteBloc({@required this.notebookLocalDb}) : super(const NoteInitial());

  Future<List<Note>> get getAllNotes => notebookLocalDb.note.getAllItem();
  Stream<List<Note>> watchAllNotes(String bookName) => notebookLocalDb.note.watchAllItem(bookName);

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is AddingNewNote) {
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
    final updateStatus = await notebookLocalDb.note.updateItem(event.note);
    final dynamic updateStatusException = _onException(updateStatus);

    if (updateStatusException is bool) {
      yield const NoteUpdated();
    } else if(updateStatusException is ExceptionCodeType) {
      yield Error(_codeTranslator(updateStatusException));
    }
  }

  dynamic _onException<R>(Either<Failure, R> status) {
    bool isException = false;
    ExceptionCodeType code;
    status.fold((l) {
      isException = true;
      code = l.code;
    }, (r) => isException = false);
    if (isException) {
      if (_exceptionCode.valid(code)) {
        return code;
      } else {
        return ExceptionCodeType.unknownError;
      }
    } else {
      return false;
    }
  }
}
