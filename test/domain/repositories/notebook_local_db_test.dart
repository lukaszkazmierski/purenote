import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart' hide isNotNull;
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:test/test.dart';

import '../../data/resources/notebook_local_db_impl_testing.dart';

void main() {
  NotebookLocalDbImplTesting notebookLocalDbImplTesting;

  setUp(() {
    notebookLocalDbImplTesting = NotebookLocalDbImplTesting();
  });

  group('Database actions for Books', () {
    test('should insert books to database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name: Value<String>('1Book'));
      const book2 = BookTableCompanion(name: Value<String>('2Book'));

      //assert
      expect(notebookLocalDbImplTesting.book, isNot(null));
      await notebookLocalDbImplTesting.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDbImplTesting.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');

      await notebookLocalDbImplTesting.book.insertItem(book2);
      listOfBooks = await notebookLocalDbImplTesting.book.getAllItem();

      expect(listOfBooks.length, 2);
      expect(listOfBooks, isA<List<Book>>());

    });

    test('should insert and update book in database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('1Book'));

      //assert
      expect(notebookLocalDbImplTesting.book, isNot(null));
      await notebookLocalDbImplTesting.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDbImplTesting.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');
      expect(listOfBooks, isA<List<Book>>());

      await notebookLocalDbImplTesting.book.updateItem(
          listOfBooks[0].copyWith(name: '1B00k1'));
      listOfBooks = await notebookLocalDbImplTesting.book.getAllItem();

      expect(listOfBooks[0].name, '1B00k1');

    });

    test('should insert and delete book in database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('1Book'));

      //assert
      expect(notebookLocalDbImplTesting.book, isNot(null));
      await notebookLocalDbImplTesting.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDbImplTesting.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');
      expect(listOfBooks, isA<List<Book>>());

      await notebookLocalDbImplTesting.book.deleteItem(listOfBooks[0]);
      listOfBooks = await notebookLocalDbImplTesting.book.getAllItem();
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
      expect(notebookLocalDbImplTesting.note, isNot(null));
      await notebookLocalDbImplTesting.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');

      await notebookLocalDbImplTesting.note.insertItem(note2);
      listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();

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
      expect(notebookLocalDbImplTesting.note, isNot(null));
      await notebookLocalDbImplTesting.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');
      expect(listOfNotes, isA<List<Note>>());

      await notebookLocalDbImplTesting.note.updateItem(
          listOfNotes[0].copyWith(title: 'contacts'));
      listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();

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
      expect(notebookLocalDbImplTesting.note, isNot(null));
      await notebookLocalDbImplTesting.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');
      expect(listOfNotes, isA<List<Note>>());

      await notebookLocalDbImplTesting.note.deleteItem(listOfNotes[0]);
      listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();
      expect(listOfNotes.length, 0);

    });

    test('should detect new notes and returned the matching to book name', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('Important'));
      const book2 = BookTableCompanion(name:  Value<String>('Important'));


      final note1 = NoteTableCompanion(
          book: book1.name,
          title: const Value<String>('important numbers'),
          content: const Value<String>('The memo contains a list of numbers'));
      final note2 = NoteTableCompanion(
          book: book1.name,
          title: const Value<String>('space info'),
          content: const Value<String>('The united crew virtually offers the hurq. Wobble without voyage, and we won’t invade an astronaut. '));
      final note3 = NoteTableCompanion(
          book: book2.name,
          title: const Value<String>('recipe'),
          content: const Value<String>('Try fluffing popcorn paste tossed with whiskey. '));

      //assert
      expect(notebookLocalDbImplTesting.note, isNotNull);

      await notebookLocalDbImplTesting.note.insertItem(note1);
      await notebookLocalDbImplTesting.note.insertItem(note2);
      await notebookLocalDbImplTesting.note.insertItem(note3);

      final streamOfNotes = notebookLocalDbImplTesting.note.watchAllItem(book1.name.value);
      expect(streamOfNotes, isA<Stream<List<Note>>>());

      const int i = 0;
      streamOfNotes.listen(
          expectAsync1<void, List<Note>>((note) {
            expect(note[i].title, note1.title.value);
            expect(note[i+1].title, note2.title.value);
          }, max: -1)
      );

      final List<Note> listOfNotes = await notebookLocalDbImplTesting.note.getAllItem();
      expect(listOfNotes, isA<List<Note>>());

    });
  });

  tearDown(() async {
    await notebookLocalDbImplTesting.dispose();
  });
}

