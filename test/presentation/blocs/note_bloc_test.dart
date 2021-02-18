import 'package:bloc_test/bloc_test.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:test/test.dart';

import '../../service_locator/service_locator.dart';

void main() {
  setUpAll(() {
    locatorTest.register();
  });

  group('NoteBloc tests', () {
    //arrange
    //act
    const note1 = NoteTableCompanion(
      book: Value<String>('Other'),
        title: Value<String>('Homos manducare!'),
        content: Value<String>('Who can receive the love and heaven of '
            'a self if he has the evil meditation of the lama?'));

    const note2 = NoteTableCompanion(
      book: Value<String>('Other'),
        title: Value<String>('Sunt absolutioes amor brevis.'),
        content: Value<String>(
            'Uniqueness doesn’t purely love any lord — but the source is what eases.'));

    //assert
    blocTest('emits [NoteListUpdate] when adding note successful',
        build: () => locatorTest.get<NoteBloc>(),
        act: (NoteBloc bloc) {
          bloc.add(const AddingNewNote(note1));
          bloc.add(const AddingNewNote(note2));
        },
        expect: [const NoteListUpdate()]);

    blocTest('emits [NoteListUpdate] when remove note successful',
        build: () => locatorTest.get<NoteBloc>(),
        act: (NoteBloc bloc) async {
          bloc.notebookLocalDb.note.insertItem(note2);
          final Note addedNote = (await bloc.getAllNotes).first;
          bloc.add(RemoveNote(addedNote));
        },
        expect: [const NoteListUpdate()]);

    blocTest('emits [NoteUpdate] when remove note successful',
        build: () => locatorTest.get<NoteBloc>(),
        act: (NoteBloc bloc) async {
          bloc.notebookLocalDb.note.insertItem(note2);
          final Note addedNote = (await bloc.getAllNotes).first;
          bloc.add(UpdateNote(addedNote.copyWith(title: 'new title')));
        },
        expect: [const NoteUpdated()]);
  });
}
