import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notebook_event.dart';
part 'notebook_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  NotebookBloc() : super(NotebookInitial());

  @override
  Stream<NotebookState> mapEventToState(
    NotebookEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
