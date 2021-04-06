import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';

class NoteAppBar  {
  final BuildContext context;
  final String title;

  const NoteAppBar({@required this.context, this.title});

  AppBar call() =>
      AppBar(
        title: Text(title),
        actions: _actions,
    );

  List<Widget> get _actions {
    return <Widget> [
      IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => ExtendedNavigator.of(context)
              .push(Routes.settingsPage)
      )
    ];
  }
}
