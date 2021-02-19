import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/service_locator/service_locator.dart';

TextEditingController _titleTextController;
TextEditingController _contentTextController;


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
          return _Body(note: note);
        }));
  }
}

class MainLayout extends StatefulWidget {
  final Note note;

  const MainLayout({@required this.note, Key key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _Body extends StatelessWidget {
  final Note note;

  const _Body({
    Key key,
    @required this.note
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: _NoteForm(note: note),
                ))),
        onWillPop: () {
          context.read<NoteBloc>().add(UpdateNote(note.copyWith(
              title: _titleTextController.text,
              content: _contentTextController.text)));
          return Future.value(true);
        });
  }
}

class _NoteFormState extends State<_NoteForm> {
  final _formKey = GlobalKey<FormState>();
  Timer updateNoteTimer;
  Note note;

  @override
  void initState() {
    note = widget.note;
    updateNoteTimer = periodicUpdateNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      widthFactor: 0.95,
      heightFactor: 0.95,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
                child: TextFormField(
                  controller: _titleTextController,
                  onSaved: onSave,
                  maxLength: 30,


                )),
            Expanded(
                flex: 12,
                child: TextFormField(
                  controller: _contentTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your content note',
                  ),
                  onSaved: onSave,
                  maxLines: null,
                )),
          ],
        ),
      )
    );
  }



  void onSave(String value) {
    context.read<NoteBloc>().add(UpdateNote(note.copyWith(
        title: _titleTextController.text,
        content: _contentTextController.text)));
  }

  Timer periodicUpdateNote() {
    return Timer.periodic(const Duration(seconds: 10), (timer) {
      _formKey.currentState.save();
    });
  }

  @override
  void dispose() {
    updateNoteTimer.cancel();
    super.dispose();
  }
}

class _NoteForm extends StatefulWidget {
  final Note note;

  const _NoteForm({@required this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}


