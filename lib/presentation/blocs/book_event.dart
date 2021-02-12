part of 'book_bloc.dart';

@immutable
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}


class AddingNewBook extends BookEvent {
  final BookTableCompanion book;

  const AddingNewBook(this.book);

  @override
  List<Object> get props => [book];
}

class RemoveBook extends BookEvent {
  final Book book;

  const RemoveBook(this.book);
  @override
  List<Object> get props => [book];

}

class RenameBook extends BookEvent {
  final Book book;
  final String name;

  const RenameBook({this.book, this.name});
  @override
  List<Object> get props => [book, name];
}

