import 'package:flutter/material.dart';

class BookNameFormDialog extends StatelessWidget {
  const BookNameFormDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.25,
            child: Container(color: Colors.white, child: const _DialogContent()),
          ),
        ],
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.9,
      heightFactor: 0.9,
      child: Column(
        children: <Widget>[
          const Text('Creating a new book'),
          TextFormField(
            maxLength: 30,
            decoration: const InputDecoration(
              labelText: 'name',
            ),
          ),
          
          Row(
            children: [
              const SizedBox(),
              RawMaterialButton(onPressed: () {}, child: const Text('Cancel')),
              RawMaterialButton(onPressed: () {}, child: const Text('Create'))
            ],
          )
        ],
      ),
    );
  }
}
