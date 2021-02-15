part of 'note_bloc.dart';

@immutable
abstract class NoteState extends Equatable {
  const NoteState();
  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {
  const NoteInitial();
  @override
  List<Object> get props => [];
}

class NoteListUpdate extends NoteState {
  const NoteListUpdate();
  @override
  List<Object> get props => [];
}
