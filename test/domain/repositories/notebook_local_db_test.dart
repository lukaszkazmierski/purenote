import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:test/test.dart';

import '../../data/resources/notebook_local_db_impl_testing.dart';


void main() {
  NotebookLocalDbImplTesting notebookLocalDbImplMock;

  setUp(() {
    notebookLocalDbImplMock = NotebookLocalDbImplTesting();
  });

  group('Database actions for Books', () {
    test('should insert books to database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name: Value<String>('1Book'));
      const book2 = BookTableCompanion(name: Value<String>('2Book'));

      //assert
      expect(notebookLocalDbImplMock.book, isNot(null));
      await notebookLocalDbImplMock.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDbImplMock.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');

      await notebookLocalDbImplMock.book.insertItem(book2);
      listOfBooks = await notebookLocalDbImplMock.book.getAllItem();

      expect(listOfBooks.length, 2);
      expect(listOfBooks, isA<List<Book>>());

    });

    test('should insert and update book in database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('1Book'));

      //assert
      expect(notebookLocalDbImplMock.book, isNot(null));
      await notebookLocalDbImplMock.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDbImplMock.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');
      expect(listOfBooks, isA<List<Book>>());

      await notebookLocalDbImplMock.book.updateItem(
          listOfBooks[0].copyWith(name: '1B00k1'));
      listOfBooks = await notebookLocalDbImplMock.book.getAllItem();

      expect(listOfBooks[0].name, '1B00k1');

    });

    test('should insert and delete book in database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('1Book'));

      //assert
      expect(notebookLocalDbImplMock.book, isNot(null));
      await notebookLocalDbImplMock.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDbImplMock.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');
      expect(listOfBooks, isA<List<Book>>());

      await notebookLocalDbImplMock.book.deleteItem(listOfBooks[0]);
      listOfBooks = await notebookLocalDbImplMock.book.getAllItem();
      expect(listOfBooks.length, 0);

    });
  });

  group('Database actions for Notes', () {
    test('should insert notes to database', () async {
      //arrange
      //act
      const bookWithNotes = BookTableCompanion(name:  Value<String>('Important'));
      final note1 = NoteTableCompanion(
          book: bookWithNotes.name,
          title: const Value<String>('important numbers'),
          content: const Value<String>('The memo contains a list of numbers'));
      final note2 = NoteTableCompanion(
          book: bookWithNotes.name,
          title: const Value<String>('meeting date'),
          content: const Value<String>('The memo contains meeting date'));

      //assert
      expect(notebookLocalDbImplMock.note, isNot(null));
      await notebookLocalDbImplMock.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDbImplMock.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');

      await notebookLocalDbImplMock.note.insertItem(note2);
      listOfNotes = await notebookLocalDbImplMock.note.getAllItem();

      expect(listOfNotes.length, 2);
      expect(listOfNotes, isA<List<Note>>());

    });

    test('should insert and update note in database', () async {
      //arrange
      //act
      const bookWithNotes = BookTableCompanion(name:  Value<String>('Important'));
      final note1 = NoteTableCompanion(
          book: bookWithNotes.name,
          title: const Value<String>('important numbers'),
          content: const Value<String>('The memo contains a list of numbers'));

      //assert
      expect(notebookLocalDbImplMock.note, isNot(null));
      await notebookLocalDbImplMock.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDbImplMock.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');
      expect(listOfNotes, isA<List<Note>>());

      await notebookLocalDbImplMock.note.updateItem(
          listOfNotes[0].copyWith(title: 'contacts'));
      listOfNotes = await notebookLocalDbImplMock.note.getAllItem();

      expect(listOfNotes[0].title, 'contacts');

    });

    test('should insert and delete book in database', () async {
      //arrange
      //act
      const bookWithNotes = BookTableCompanion(name:  Value<String>('Important'));
      final note1 = NoteTableCompanion(
          book: bookWithNotes.name,
          title: const Value<String>('important numbers'),
          content: const Value<String>('The memo contains a list of numbers'));

      //assert
      expect(notebookLocalDbImplMock.note, isNot(null));
      await notebookLocalDbImplMock.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDbImplMock.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');
      expect(listOfNotes, isA<List<Note>>());

      await notebookLocalDbImplMock.note.deleteItem(listOfNotes[0]);
      listOfNotes = await notebookLocalDbImplMock.note.getAllItem();
      expect(listOfNotes.length, 0);

    });
  });

  tearDown(() async {
    await notebookLocalDbImplMock.dispose();
  });
}

