import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';
import 'package:moor/moor.dart' hide isNotNull;
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import '../../service_locator/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfoMock();
  NotebookLocalDb notebookLocalDb;
  setUpAll(() {
    locatorTest.register();
  });

  setUp(() {
    notebookLocalDb = locatorTest.get<NotebookLocalDb>();
  });

  group('Database actions for Books', () {
    test('should insert books to database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name: Value<String>('1Book'));
      const book2 = BookTableCompanion(name: Value<String>('2Book'));

      //assert
      expect(notebookLocalDb.book, isNot(null));
      await notebookLocalDb.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDb.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');

      await notebookLocalDb.book.insertItem(book2);
      listOfBooks = await notebookLocalDb.book.getAllItem();

      expect(listOfBooks.length, 2);
      expect(listOfBooks, isA<List<Book>>());

      notebookLocalDb.book.deleteItem(listOfBooks[0]);
      notebookLocalDb.book.deleteItem(listOfBooks[1]);

    });

    test('should insert and update book in database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('1Book'));

      //assert
      expect(notebookLocalDb.book, isNot(null));
      await notebookLocalDb.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDb.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');
      expect(listOfBooks, isA<List<Book>>());

      await notebookLocalDb.book.updateItem(
          listOfBooks[0].copyWith(name: '1B00k1'));
      listOfBooks = await notebookLocalDb.book.getAllItem();

      expect(listOfBooks[0].name, '1B00k1');
      notebookLocalDb.book.deleteItem(listOfBooks[0]);
    });

    test('should insert and delete book in database', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('1Book'));

      //assert
      expect(notebookLocalDb.book, isNot(null));
      await notebookLocalDb.book.insertItem(book1);
      List<Book> listOfBooks = await notebookLocalDb.book.getAllItem();

      expect(listOfBooks.length, 1);
      expect(listOfBooks[0].name, '1Book');
      expect(listOfBooks, isA<List<Book>>());

      await notebookLocalDb.book.deleteItem(listOfBooks[0]);
      listOfBooks = await notebookLocalDb.book.getAllItem();
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
      expect(notebookLocalDb.note, isNot(null));
      await notebookLocalDb.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDb.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');

      await notebookLocalDb.note.insertItem(note2);
      listOfNotes = await notebookLocalDb.note.getAllItem();

      expect(listOfNotes.length, 2);
      expect(listOfNotes, isA<List<Note>>());

      notebookLocalDb.note.deleteItem(listOfNotes[0]);
      notebookLocalDb.note.deleteItem(listOfNotes[1]);
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
      expect(notebookLocalDb.note, isNot(null));
      await notebookLocalDb.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDb.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');
      expect(listOfNotes, isA<List<Note>>());

      await notebookLocalDb.note.updateItem(
          listOfNotes[0].copyWith(title: 'contacts'));
      listOfNotes = await notebookLocalDb.note.getAllItem();

      expect(listOfNotes[0].title, 'contacts');
      notebookLocalDb.note.deleteItem(listOfNotes[0]);
    });

    test('should insert and delete notes in database', () async {
      //arrange
      //act
      const bookWithNotes = BookTableCompanion(name:  Value<String>('Important'));
      final note1 = NoteTableCompanion(
          book: bookWithNotes.name,
          title: const Value<String>('important numbers'),
          content: const Value<String>('The memo contains a list of numbers'));

      //assert
      expect(notebookLocalDb.note, isNot(null));
      await notebookLocalDb.note.insertItem(note1);
      List<Note> listOfNotes = await notebookLocalDb.note.getAllItem();

      expect(listOfNotes.length, 1);
      expect(listOfNotes[0].title, 'important numbers');
      expect(listOfNotes, isA<List<Note>>());

      await notebookLocalDb.note.deleteItem(listOfNotes[0]);
      listOfNotes = await notebookLocalDb.note.getAllItem();
      expect(listOfNotes.length, 0);
    });

    test('should convert books and notes to json', () async {
      //arrange
      //act
      const book1 = BookTableCompanion(name:  Value<String>('Recipes'));
      final note1 = NoteTableCompanion(
          book: book1.name,
          title: const Value<String>('Pizza'),
          content: const Value<String>('This is a classic homemade pizza recipe, '
              'including a pizza dough recipe, topping suggestions, and step-by-step '
              'instructions with photos. Make perfect pizza at home! '));
      final note2 = NoteTableCompanion(
          book: book1.name,
          title: const Value<String>('Chicken Fried Rice'),
          content: const Value<String>('Chicken Fried Rice! This take-out classic is '
              'an easy weeknight meal! Its made on the stovetop with chicken, eggs, '
              'onions, carrots, peas, and rice.'));

      const book2 = BookTableCompanion(name:  Value<String>('Meetings'));
      final note3 = NoteTableCompanion(
          book: book2.name,
          title: const Value<String>('Meeting with friends'),
          content: const Value<String>('Sunday April 26, 2021'));
      //assert
      expect(notebookLocalDb.note, isNot(null));
      await notebookLocalDb.book.insertItem(book1);
      await notebookLocalDb.note.insertItem(note1);
      await notebookLocalDb.note.insertItem(note2);

      await notebookLocalDb.book.insertItem(book2);
      await notebookLocalDb.note.insertItem(note3);

      final dbAsJson = await notebookLocalDb.toJson();
      expect(dbAsJson, isNot(null));
      expect(dbAsJson, isA<Map<String, dynamic>>());

      final notes = await notebookLocalDb.note.getAllItem();
      expect(dbAsJson, {
        book1.name.value: notes.where((x) => x.book == 'Recipes'),
        book2.name.value: notes.where((x) => x.book == 'Meetings')
      });

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
      expect(notebookLocalDb.note, isNotNull);

      await notebookLocalDb.note.insertItem(note1);
      await notebookLocalDb.note.insertItem(note2);
      await notebookLocalDb.note.insertItem(note3);

      final streamOfNotes = notebookLocalDb.note.watchAllItem(book1.name.value);
      expect(streamOfNotes, isA<Stream<List<Note>>>());

      const int i = 0;
      streamOfNotes.listen(
          expectAsync1<void, List<Note>>((note) {
            expect(note[i].title, note1.title.value);
            expect(note[i+1].title, note2.title.value);
          }, max: -1)
      );

      final List<Note> listOfNotes = await notebookLocalDb.note.getAllItem();
      expect(listOfNotes, isA<List<Note>>());

    });
  });

}

void packageInfoMock() {
  const MethodChannel('plugins.flutter.io/package_info').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'ABC',
        'packageName': 'A.B.C',
        'version': '1.0.0',
        'buildNumber': ''
      };
    }
    return null;
  });
}
