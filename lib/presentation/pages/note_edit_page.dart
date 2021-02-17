import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/service_locator/service_locator.dart';

class NoteEditPage extends StatelessWidget {
  final note;

  const NoteEditPage({@required this.note, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<NoteBloc>(),
      child: MainLayout(note: note as Note),
    );
  }
}

class _MainLayoutState extends State<MainLayout> {
  Note note;
  TextEditingController _titleTextController;
  TextEditingController _contentTextController;
  @override
  void initState() {
    super.initState();
    note = widget.note;
    _titleTextController = TextEditingController(text: note.title);
    _contentTextController = TextEditingController(text: note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('note edit'),
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
          builder: (BuildContext context, state) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
          constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
            ),
          child: IntrinsicHeight(
            child: FractionallySizedBox(
                alignment: Alignment.topCenter,
                widthFactor: 0.95,
                heightFactor: 0.95,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _titleTextController,
                        )),
                    Expanded(
                        flex: 12,
                        child: TextFormField(
                          controller: _contentTextController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                          ),
                          maxLines: null,
                        )),
                  ],
                ),
            ),


            )


            ));
      })
    );
  }
}



class MainLayout extends StatefulWidget {
  final Note note;

  const MainLayout({@required this.note, Key key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}
