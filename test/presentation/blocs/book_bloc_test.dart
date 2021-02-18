import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import '../../service_locator/service_locator.dart';

void main() {
  setUpAll(() {
    locatorTest.register();
  });

  group('BookBloc tests', () {
    //arrange
    //act
    const book1 = BookTableCompanion(name: Value<String>('1Book'));
    const book2 = BookTableCompanion(name: Value<String>('important Book'));

    //assert
    blocTest('emits [BookListUpdate] when adding book successful',
        build: () => locatorTest.get<BookBloc>(),
        act: (BookBloc bloc) {
          bloc.add(const AddingNewBook(book1));
          bloc.add(const AddingNewBook(book2));
        },
        expect: [const BookListUpdate()]);


    blocTest('emits [BookListUpdate] when remove book successful',
        build: () => locatorTest.get<BookBloc>(),
        act: (BookBloc bloc) async {
          bloc.notebookLocalDb.book.insertItem(book1);
          final List<Book> books = await bloc.notebookLocalDb.book.getAllItem();
          bloc.add(RemoveBook(books[0]));
        },
        expect: [const BookListUpdate()]);

    blocTest('emits [BookListUpdate] when rename book successful',
        build: () => locatorTest.get<BookBloc>(),
        act: (BookBloc bloc) async {
          bloc.notebookLocalDb.book.insertItem(book1);
          final List<Book> books = await bloc.notebookLocalDb.book.getAllItem();
          bloc.add(RenameBook(book: books[0], name: 'otherBook'));
        },
        expect: [const BookListUpdate()]);
  });
}
