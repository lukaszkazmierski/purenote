import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';

class NoteEditPage extends StatelessWidget {
  final note;

  const NoteEditPage({@required this.note, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => NoteBloc(notebookLocalDb), child: MainLayout(note: note as Note),);

  }
}

class _MainLayoutState extends State<MainLayout> {
  Note note;
  TextEditingController _titleTextController;
  @override
  void initState() {
    super.initState();
    note = widget.note;
    _titleTextController = TextEditingController(text: note.title);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('note edit'),),
      body: BlocBuilder<NoteBloc, NoteState>(builder: (BuildContext context, state) {
        return Column(
          children: [
            Expanded(child: TextFormField(
              controller: _titleTextController,
            ))
          ],
        );
    }),
    );
  }
}

class MainLayout extends StatefulWidget {
  final Note note;

  const MainLayout({@required this.note ,Key key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();

}