import 'package:flutter/material.dart';
import 'package:notebook/core/constants/constants.dart';
import 'package:provider/provider.dart';

import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';



class BookNameFormDialog extends StatelessWidget {
  final BuildContext contextWithBloc;
  final String typeDial;

  const BookNameFormDialog({@required this.contextWithBloc, @required this.typeDial, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                child: _DialogContent(contextWithBloc: contextWithBloc, typeDial: typeDial,))
          ],
        ),
      )
    );
  }
}

class _DialogContent extends StatelessWidget {
  final TextEditingController _nameFieldController = TextEditingController();
  final BuildContext contextWithBloc;
  final String typeDial;

  _DialogContent({
    @required this.contextWithBloc,
    @required this.typeDial,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.9,
      child: Column(
        children: <Widget>[
          typeDial == 'Add' ? const Text('Creating a new book') : const Text('Rename book'),
          TextFormField(
            controller: _nameFieldController,
            maxLength: Constants.maxBookTitleLength,
            decoration: const InputDecoration(
              labelText: 'name',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(),
              RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              RawMaterialButton(
                  onPressed: () {
                    if (typeDial == 'Add') {
                      final book = BookTableCompanion(
                          name: Value<String>(_nameFieldController.text));
                      contextWithBloc.read<BookBloc>().add(AddingNewBook(book));
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, _nameFieldController.text);
                    }


                  },
                  child: typeDial == 'Add' ? const Text('Create') : const Text('Rename'))
            ],
          )
        ],
      ),
    );
  }
}
