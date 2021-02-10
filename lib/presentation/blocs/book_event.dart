part of 'book_bloc.dart';

@immutable
abstract class BookEvent extends Equatable {
  const BookEvent();
}


class AddingNewBook extends BookEvent {
  final BookTableCompanion book;

  const AddingNewBook(this.book);

  @override
  List<Object> get props => [book];
}

class RemoveBook extends BookEvent {
  final BookTableCompanion book;

  const RemoveBook(this.book);

  @override
  List<Object> get props => [];
}

class RenameBook extends BookEvent {
  final BookTableCompanion book;
  final String name;

  const RenameBook({this.book, this.name});

  @override
  List<Object> get props => [name];
}

