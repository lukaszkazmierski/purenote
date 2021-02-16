import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:notebook/injection/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureInjection(String environment) =>
    $initGetIt(getIt, environment: environment);

