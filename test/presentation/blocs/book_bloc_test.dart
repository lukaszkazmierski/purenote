import 'package:bloc_test/bloc_test.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';

import 'package:test/test.dart';

import '../../data/resources/notebook_local_db_impl_testing.dart';

void main() {
  NotebookLocalDbImplTesting notebookLocalDbImplTesting;
  BookBloc bookBloc;

  setUp(() {
    notebookLocalDbImplTesting = NotebookLocalDbImplTesting();
    bookBloc = BookBloc(notebookLocalDbImplTesting);
  });

  group('BookBloc tests', () {
    //arrange
    //act
    const book1 = BookTableCompanion(name: Value<String>('1Book'));
    const book2 = BookTableCompanion(name: Value<String>('important Book'));

    //assert
    blocTest('emits [BookListUpdate] when adding book successful',
        build: () => bookBloc,
        act: (BookBloc bloc) {
          bloc.add(const AddingNewBook(book1));
          bloc.add(const AddingNewBook(book2));
        },
        expect: [
          const BookListUpdate()]);


    blocTest('emits [BookListUpdate] when remove book successful',
        build: () => bookBloc,
        act: (BookBloc bloc) async {
          notebookLocalDbImplTesting.book.insertItem(book1);
          final List<Book> books = await notebookLocalDbImplTesting.book.getAllItem();
          return bloc.add(RemoveBook(books[0]));
        },
        expect: [const BookListUpdate()]);

    blocTest('emits [BookListUpdate] when rename book successful',
        build: () => bookBloc,
        act: (BookBloc bloc) async {
          notebookLocalDbImplTesting.book.insertItem(book1);
          final List<Book> books = await notebookLocalDbImplTesting.book.getAllItem();
          return bloc.add(RenameBook(book: books[0], name: 'otherBook'));
        },
        expect: [const BookListUpdate()]);
  });
  tearDown(() async {
    await notebookLocalDbImplTesting.dispose();
  });
}
