import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';

export 'package:moor/moor.dart' show Value;
export 'package:notebook/data/resources/moor_config/moor_database.dart' show Book, BookTableCompanion;
export 'package:notebook/domain/repositories/notebook_local_db.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final NotebookLocalDb notebookLocalDb;

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
    notebookLocalDb.book.insertItem(event.book);
    yield const BookListUpdate();
  }

  Stream<BookState> mapRemoveBookToState(RemoveBook event) async* {
    notebookLocalDb.book.deleteItem(event.book);
    yield const BookListUpdate();
  }

  Stream<BookState> mapRenameBookToState(RenameBook event) async* {
    final updatedBook = event.book.copyWith(name: event.name);
    notebookLocalDb.book.updateItem(updatedBook);
    yield const BookListUpdate();
  }
}
