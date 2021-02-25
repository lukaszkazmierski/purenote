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
  final Book book;

  const BookNameFormDialog({this.book, Key key})
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
                    child: _DialogContent<T>(book: book))
              ],
            ),
          )),
    );
  }
}

class _DialogContent<T> extends StatelessWidget {
  final TextEditingController _nameFieldController = TextEditingController();
  final Book book;
  String currentErr;

  _DialogContent({
    this.book,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listener: (context, state) {
        if (state is BookListUpdate || state is BookRenameUpdate) {
          Navigator.pop(context);
        } else if (state is Error) {
          currentErr = state.message;
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

            BlocBuilder<BookBloc, BookState>(
              builder: (context, builder) {
                return TextFormField(
                  controller: _nameFieldController,
                  maxLength: Constants.maxBookTitleLength,
                  decoration: InputDecoration(
                      labelText: 'name',
                      errorText: currentErr
                  ),
                );
              },
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
                        context.read<BookBloc>().add(RenameBook(book: book, name: _nameFieldController.text));
                      } else {
                        final book = BookTableCompanion(
                            name: Value<String>(_nameFieldController.text));
                        context.read<BookBloc>().add(AddingNewBook(book));
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
