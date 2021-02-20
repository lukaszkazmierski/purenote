import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moor/moor.dart';
import 'package:notebook/core/utils/extensions/default_note_companion_extension.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/presentation/widgets/add_item_btn.dart';
import 'package:notebook/presentation/widgets/centered_circular_progress_indicator.dart';
import 'package:notebook/service_locator/service_locator.dart';

class BookWithNotesPage extends StatelessWidget {
  final String bookName;

  const BookWithNotesPage({@required this.bookName, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
        create: (_) => locator.get<NoteBloc>(),
        child: MainLayout(bookName: bookName));
  }
}

class MainLayout extends StatelessWidget {
  final String bookName;

  const MainLayout({@required this.bookName, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notes'),
      ),
      body: StreamBuilder(
          stream: context.read<NoteBloc>().watchAllNotes(bookName),
          builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CenteredCircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return const CenteredCircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SlidableTile(note: snapshot.data[index]);
                      });
                }
            }
          }),
      floatingActionButton: AddItemBtn(onPressed: () {
        final note = DefaultNoteCompanion(const NoteTableCompanion())
            .create(bookName: bookName);
        context.read<NoteBloc>().add(AddingNewNote(note));
      }),
    );
  }
}

class SlidableTile extends StatelessWidget {
  final SlidableController slidableController = SlidableController();
  final Note note;

  SlidableTile({
    Key key,
    @required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key(note.title),
        controller: slidableController,
        actionPane: const SlidableDrawerActionPane(),
        child: ListTile(
          title: Text(note.title),
          onTap: () {
            ExtendedNavigator.of(context).push(Routes.noteEditPage,
                arguments: NoteEditPageArguments(note: note));
          },
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => context.read<NoteBloc>().add(RemoveNote(note)),
          ),
        ]);
  }
}
