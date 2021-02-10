
import 'package:flutter/material.dart';

class AddItemBtn extends StatelessWidget {
  final void Function() onPressed;

  const AddItemBtn({@required this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}