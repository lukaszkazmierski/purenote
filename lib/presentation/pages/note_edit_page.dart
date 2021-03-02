import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notebook/core/constants/constants.dart';
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
                        ))
                ),
            onWillPop: () {
              context.read<NoteBloc>().add(UpdateNote(note.copyWith(
                  title: _titleTextController.text,
                  content: _contentTextController.text)));

              return Future.value(true);
            }));
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
                    Expanded(child: Icon(Icons.title)),
                    Expanded(
                      flex: 11,

                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _titleTextController,
                            onChanged: (String value) {
                              context
                                  .read<NoteBloc>()
                                  .add(UpdateNote(note.copyWith(title: value)));
                            },
                            maxLength: Constants.maxNoteTitleLength,
                            decoration: InputDecoration(
                              errorText: currentErr,
                            ),
                          ),
                        )),
                  ],
                ),
                Expanded(
                    flex: 12,
                    child: TextFormField(
                      controller: _contentTextController,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,

                      expands: true,
                      style: TextStyle(height: 1.4),
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

/*
class MultipleLinesPainterController {
  final ScrollController _scrollController;
  final double _offsetBetweenLinesModulo;
  final startPosMultiplier = 0.176;
  final betweenLinesPosMultiplier = 0.056;
  final int initNumberOfLines;
  int currentNumberOfLines;


  MultipleLinesPainterController({@required ScrollController scrollController,@required double screenHeight}) :
        _scrollController = scrollController,
        _offsetBetweenLinesModulo = screenHeight * 0.184,
        initNumberOfLines = ((screenHeight * 0.6) / (screenHeight * 0.036)).round() {
    currentNumberOfLines = initNumberOfLines;

  }

  void shouldRecalculateLines() {
    switch(_scrollController.position.userScrollDirection) {
      case ScrollDirection.reverse:
        if (_scrollController.offset % _offsetBetweenLinesModulo >= 30) {
          currentNumberOfLines++;
        }
        break;

      case ScrollDirection.forward:
        if (currentNumberOfLines > initNumberOfLines
            && _offsetBetweenLinesModulo - 10<= _scrollController.offset % _offsetBetweenLinesModulo) {
          currentNumberOfLines--;
        }
        if(_scrollController.offset <= 5) {
          currentNumberOfLines = initNumberOfLines;
        }
        break;
      case ScrollDirection.idle:
        break;
    }
  }
}


class PagePainter extends CustomPainter {
  final MultipleLinesPainterController _controller;

  PagePainter({@required ScrollController scrollController ,@required double screenHeight})
      : _controller = MultipleLinesPainterController(
    scrollController: scrollController,
      screenHeight: screenHeight);

  @override
  void paint(Canvas canvas, Size size) {
    _controller.shouldRecalculateLines();

    final paintDarkgrey = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    for(int i = 0; i < _controller.currentNumberOfLines; i++) {
      canvas.drawLine(Offset(0, size.height * (_controller.startPosMultiplier + (i * _controller.betweenLinesPosMultiplier))),
          Offset(size.width, size.height * (_controller.startPosMultiplier + (i * _controller.betweenLinesPosMultiplier))), paintDarkgrey);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}*/