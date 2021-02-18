import 'package:get_it/get_it.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/service_locator/environment.dart';

class Locator {
   final _sl = GetIt.instance;
   final String environment;

   Locator({this.environment = Environment.prod});

   T get<T>() => _sl.get<T>();

   void register() {
    _sl.registerFactory<BookBloc>(() => BookBloc(notebookLocalDb: _sl()));
    _sl.registerFactory<NoteBloc>(() => NoteBloc(notebookLocalDb: _sl()));
    _dbMode();
   }

   void _dbMode() {
     switch (environment) {
       case Environment.prod:
         _sl.registerSingleton<NotebookLocalDb>(NotebookLocalDbImpl());
         break;
       case Environment.test:
         _sl.registerFactory<NotebookLocalDb>(() => NotebookLocalDbImpl.testing());
         break;
     }
   }
}

final Locator locator = Locator();