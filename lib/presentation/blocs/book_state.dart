part of 'book_bloc.dart';

@immutable
abstract class BookState extends Equatable {
  const BookState();
}

class BookInitial extends BookState {
  @override
  List<Object> get props => [];
}

class BookNameChanged extends BookState {
  @override
  List<Object> get props => [];
}

class BookListUpdate extends BookState {
  @override
  List<Object> get props => [];
}


