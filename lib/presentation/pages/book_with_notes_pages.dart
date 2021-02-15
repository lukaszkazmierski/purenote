import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/presentation/widgets/add_item_btn.dart';
import 'package:notebook/presentation/widgets/centered_circular_progress_indicator.dart';

class BookWithNotesPage extends StatelessWidget {
  final String bookName;

  const BookWithNotesPage({@required this.bookName, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(bookName);
    return BlocProvider<NoteBloc>(
        create: (_) => NoteBloc(notebookLocalDb),
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
                return CenteredCircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return CenteredCircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index].title),
                          onTap: () {
                            ExtendedNavigator.of(context).push(Routes.noteEditPage, arguments: NoteEditPageArguments(note: snapshot.data[index]));
                          },
                        );
                      });
                }
            }
          }),
      floatingActionButton: AddItemBtn(onPressed: () {
        final note = NoteTableCompanion(title: Value<String>('nowa notatka'), content: Value<String>('nowa notatka'));
        context.read<NoteBloc>().add(AddingNewNote(note));
      }),
    );
  }
}
