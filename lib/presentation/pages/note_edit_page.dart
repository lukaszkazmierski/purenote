import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/core/config/theme/app_themes.dart';
import 'package:notebook/core/constants/constants.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/presentation/widgets/note_app_bar.dart';
import 'package:notebook/service_locator/service_locator.dart';

TextEditingController _titleTextController;
TextEditingController _contentTextController;

class NoteEditPage extends StatelessWidget {
  final dynamic note;

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
        appBar: const NoteAppBar(title: '')(),
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

class _BodyState extends State<_Body> {
  ScrollController _scrollController;
  Note note;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {},
        child: WillPopScope(
            onWillPop: () {
              context.read<NoteBloc>().add(UpdateNote(note.copyWith(
                  title: _titleTextController.text,
                  content: _contentTextController.text)));

              return Future.value(true);
            },
            child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: _NoteForm(note: note),
                    )))));
  }
}

class _Body extends StatefulWidget {
  final Note note;

  const _Body({@required this.note});

  @override
  _BodyState createState() => _BodyState();
}

class _NoteFormState extends State<_NoteForm> {
  final _formKey = GlobalKey<FormState>();
  Note note;
  String currentErr;
  @override
  void initState() {
    note = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is Error) {
          currentErr = state.message;
        } else {
          currentErr = null;
        }
      },
      child: FractionallySizedBox(
          alignment: Alignment.topCenter,
          widthFactor: 0.95,
          heightFactor: 0.95,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 22),
                        child: Icon(Icons.title),
                      ),
                    ),
                    Expanded(
                        flex: 11,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _titleTextController,
                            onChanged: (String value) {
                              context
                                  .read<NoteBloc>()
                                  .add(UpdateNote(note.copyWith(title: value)));
                            },
                            maxLength: Constants.maxNoteTitleLength,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: Constants.spaceBetweenTextAndUnderline),
                              errorText: currentErr,
                              counterText: "",
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Expanded(
                    flex: 12,
                    child: TextFormField(
                      controller: _contentTextController,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      style: lightTheme.textStyle(height: 1.6),
                      onChanged: (String value) {
                        context
                            .read<NoteBloc>()
                            .add(UpdateNote(note.copyWith(content: value)));
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Your content',
                      ),
                      maxLines: null,
                    )),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _NoteForm extends StatefulWidget {
  final Note note;

  const _NoteForm({@required this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}
