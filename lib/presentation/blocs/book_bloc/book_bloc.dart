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

export 'package:moor/moor.dart' show Value;
export 'package:notebook/data/resources/moor_config/moor_database.dart'
    show Book, BookTableCompanion;
export 'package:notebook/domain/repositories/notebook_local_db.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final NotebookLocalDb notebookLocalDb;
  final ExceptionCode _exceptionCode = locator.get<ExceptionCode>();
  final ExceptionCodeTranslator _codeTranslator =
      locator.get<ExceptionCodeTranslator>();

  BookBloc({@required this.notebookLocalDb}) : super(const BookInitial());

  Future<List<Book>> get getAllBooks => notebookLocalDb.book.getAllItem();
  Stream<List<Book>> get watchAllBooks => notebookLocalDb.book.watchAllItem();

  @override
  Stream<BookState> mapEventToState(
    BookEvent event,
  ) async* {
    if (event is AddingNewBook) {
      yield* mapAddingNewBookToState(event);
    } else if (event is RemoveBook) {
      yield* mapRemoveBookToState(event);
    } else if (event is RenameBook) {
      yield* mapRenameBookToState(event);
    }
  }

  Stream<BookState> mapAddingNewBookToState(AddingNewBook event) async* {
    final bookExists = await notebookLocalDb.book.isExists(itemName: event.book.name.value);
    final dynamic bookExistsExceptionStatus = _onException<bool>(bookExists);

    if (bookExistsExceptionStatus is ExceptionCodeType) {
      yield Error(_codeTranslator(bookExistsExceptionStatus));
      yield const RefreshState();
      return;
    }

    final insertStatus = await notebookLocalDb.book.insertItem(event.book);
    final dynamic insertExceptionStatus = _onException<int>(insertStatus);
    if (bookExistsExceptionStatus is bool && insertExceptionStatus is bool) {
      yield const BookListUpdate();
    } else if(insertExceptionStatus is ExceptionCodeType) {
      yield Error(_codeTranslator(insertExceptionStatus));
      yield const RefreshState();
    }
  }

  Stream<BookState> mapRemoveBookToState(RemoveBook event) async* {
    await notebookLocalDb.book.deleteItem(event.book);
    yield const BookListUpdate();
  }

  Stream<BookState> mapRenameBookToState(RenameBook event) async* {
    final bookExists = await notebookLocalDb.book.isExists(itemName: event.name);
    final dynamic bookExistsExceptionStatus = _onException<bool>(bookExists);

    if (bookExistsExceptionStatus is ExceptionCodeType) {
      yield Error(_codeTranslator(bookExistsExceptionStatus));
      yield const RefreshState();
      return;
    }

    final updatedBook = event.book.copyWith(name: event.name);
    final updateStatus = await notebookLocalDb.book.updateItem(updatedBook);

    final dynamic exceptionStatus = _onException<bool>(updateStatus);
    if (exceptionStatus is bool) {
      yield const BookRenameUpdate();
    } else {
      yield Error(_codeTranslator(exceptionStatus as ExceptionCodeType));
      yield const RefreshState();
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
