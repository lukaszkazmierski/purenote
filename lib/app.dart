import 'package:flutter/material.dart' hide Router;
import 'package:auto_route/auto_route.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';

class App extends StatelessWidget {

  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SizedBox(),
      builder: ExtendedNavigator.builder<Router>(
          router: Router(),
          //initialRoute: '/'
      ),
    );
  }
}
