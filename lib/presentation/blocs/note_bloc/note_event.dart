part of 'note_bloc.dart';

@immutable
abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class AddingNewNote extends NoteEvent {
  final NoteTableCompanion note;

  const AddingNewNote(this.note);

  @override
  List<Object> get props => [note];
}

class RemoveNote extends NoteEvent {
  final Note note;

  const RemoveNote(this.note);
  @override
  List<Object> get props => [note];
}
