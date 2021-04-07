import 'package:get_it/get_it.dart';
import 'package:notebook/core/exceptions/exception_code.dart';
import 'package:notebook/core/exceptions/exception_code_translator.dart';
import 'package:notebook/core/exceptions/failure.dart';
import 'package:notebook/core/secure/db_encryption.dart';
import 'package:notebook/data/resources/local_settings_impl.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';
import 'package:notebook/domain/repositories/local_settings.dart';
import 'package:notebook/domain/repositories/notebook_local_db.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import 'package:notebook/presentation/blocs/note_bloc/note_bloc.dart';
import 'package:notebook/service_locator/environment.dart';
import 'package:package_info/package_info.dart';

class Locator {
   final _sl = GetIt.instance;
   final String environment;

   Locator({this.environment = Environment.prod});

   T get<T>() => _sl.get<T>();
   T getWithParam<T>(dynamic param1) => _sl.get<T>(param1: param1);


   Future<void> register() async {
    _sl.registerFactory<BookBloc>(() => BookBloc(notebookLocalDb: _sl()));
    _sl.registerFactory<NoteBloc>(() => NoteBloc(notebookLocalDb: _sl()));
    _sl.registerFactoryParam<Failure, ExceptionCodeType, void>((ec, _) => Failure(ec));
    _sl.registerLazySingleton<ExceptionCode>(() => ExceptionCodeImpl());
    _sl.registerLazySingleton<ExceptionCodeTranslator>(() => ExceptionCodeTranslatorImpl());
    final LocalSettings localSettings = LocalSettingsImpl();
    await localSettings();
    _sl.registerSingleton<LocalSettings>(localSettings);
    await _dbMode();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _sl.registerSingleton<PackageInfo>(packageInfo);
   }

   Future<void> _dbMode() async {
     switch (environment) {
       case Environment.prod:
         final DbEncryption dbEncryption = DbEncryption();
         await dbEncryption.checkKey();
         final String pass = await dbEncryption.getDbPassword;
         _sl.registerSingleton<NotebookLocalDb>(NotebookLocalDbImpl(pass));
         break;
       case Environment.test:
         _sl.registerSingleton<NotebookLocalDb>(NotebookLocalDbImpl.testing());
         break;
     }
   }
}

final Locator locator = Locator();