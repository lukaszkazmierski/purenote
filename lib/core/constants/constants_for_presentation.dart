import 'package:flutter/material.dart';

class ConstantsWidget extends InheritedWidget {
  static ConstantsWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ConstantsWidget>();

  const ConstantsWidget({Widget child, Key key})
      : super(key: key, child: child);

  //final String successMessage = 'Some message';

  @override
  bool updateShouldNotify(ConstantsWidget oldWidget) => false;
}
