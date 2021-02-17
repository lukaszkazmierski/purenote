import 'package:get_it/get_it.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';

class Locator {
   final _sl = GetIt.instance;

   T get<T>() => _sl.get<T>();

   void register() {
    _sl.registerFactory(() => BookBloc(notebookLocalDb: _sl()));
    _sl.registerFactory(() => NoteBloc(notebookLocalDb: _sl()));
    _sl.registerSingleton<NotebookLocalDb>(NotebookLocalDbImpl());
   }
}

final Locator locator = Locator();