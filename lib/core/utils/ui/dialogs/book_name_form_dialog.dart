import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/core/constants/constants.dart';
import 'package:notebook/service_locator/service_locator.dart';
import 'package:provider/provider.dart';

import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';

abstract class BookNameFormDialogType {}
class AddBookDialog implements BookNameFormDialogType {}
class RenameBookDialog implements BookNameFormDialogType {}

class BookNameFormDialog<T>
    extends StatelessWidget {

  const BookNameFormDialog({Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => locator.get<BookBloc>(),
      child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.white,
                    child: _DialogContent<T>())
              ],
            ),
          )),
    );
  }
}

class _DialogContent<T> extends StatelessWidget {
  final TextEditingController _nameFieldController = TextEditingController();
  static final _nameFieldKey = GlobalKey<FormState>();

  _DialogContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listener: (context, state) {
        if (state is Error) {
          final snackBar = SnackBar(
            content: Text(state.message),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {

              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.9,
        child: Column(
          children: <Widget>[
            if (_isRenameBookDialogType())
              const Text('Rename book')
            else
              const Text('Creating a new book'),

            TextFormField(
              key: _nameFieldKey,
              controller: _nameFieldController,
              maxLength: Constants.maxBookTitleLength,
              validator: (String value) {
              },
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
                      if (_isRenameBookDialogType()) {
                        _nameFieldKey.currentState.validate();
                        Navigator.pop(context, _nameFieldController.text);
                      } else {
                        final book = BookTableCompanion(
                            name: Value<String>(_nameFieldController.text));
                        context.read<BookBloc>().add(AddingNewBook(book));
                        Navigator.pop(context);
                      }
                    },
                    child: _isRenameBookDialogType()
                        ? const Text('Rename')
                        : const Text('Create'))
              ],
            )
          ],
        ),
      )
    );

  }

  bool _isRenameBookDialogType() {
    if (T == RenameBookDialog) {
      return true;
    } else {
      return false;
    }
  }
}
