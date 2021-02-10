part of 'book_bloc.dart';

@immutable
abstract class NotebookEvent extends Equatable {
  const NotebookEvent();
}


class AddingNewBook extends NotebookEvent {
  final BookTableCompanion book;

  const AddingNewBook(this.book);

  @override
  // TODO: implement props
  List<Object> get props => [book];
}