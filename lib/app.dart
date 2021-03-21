import 'package:flutter/material.dart' hide Router;
import 'package:auto_route/auto_route.dart';
import 'package:notebook/core/config/theme/app_themes.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/domain/repositories/local_settings.dart';
import 'package:notebook/service_locator/service_locator.dart';

class App extends StatelessWidget {

  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purenote',
      home: const SizedBox(),
      builder: ExtendedNavigator.builder<Router>(
          router: Router(),
          initialRoute: locator.get<LocalSettings>().introIsClosed()
            ? Routes.mainPage : Routes.introPage
      ),
      theme: lightTheme.getTheme(),
    );
  }
}
