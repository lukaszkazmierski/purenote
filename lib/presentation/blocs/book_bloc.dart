import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';
import 'package:notebook/domain/models/book_model.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';

export 'package:moor/moor.dart' show Value;
export 'package:notebook/data/resources/moor_config/moor_database.dart' show Book, BookTableCompanion;

part 'book_event.dart';
part 'book_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  NotebookBloc() :
        _notebookLocalDb = NotebookLocalDbImpl(),
        super(NotebookInitial());

  final NotebookLocalDb _notebookLocalDb;

  Future<List<Book>> get getAllBooks => _notebookLocalDb.book.getAllItem();
  Stream<List<Book>> get watchAllBooks => _notebookLocalDb.book.watchAllItem();
  
  @override
  Stream<NotebookState> mapEventToState(
    NotebookEvent event,
  ) async* {

    if (event is AddingNewBook) {
      mapAddingNewBookToState(event);
    }
  }

  Stream<NotebookState> mapAddingNewBookToState(AddingNewBook event) async* {
    _notebookLocalDb.book.insertItem(event.book);

  }
 }
