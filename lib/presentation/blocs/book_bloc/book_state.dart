part of 'book_bloc.dart';

@immutable
abstract class BookState extends Equatable {
  const BookState();
  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {
  const BookInitial();

  @override
  List<Object> get props => [];
}

class BookListUpdate extends BookState {
  const BookListUpdate();

  @override
  List<Object> get props => [];
}

class BookRenameUpdate extends BookState {
  const BookRenameUpdate();

  @override
  List<Object> get props => [];
}

class Error extends BookState {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}

class RefreshState extends BookState {
  const RefreshState();

  @override
  List<Object> get props => [];
}