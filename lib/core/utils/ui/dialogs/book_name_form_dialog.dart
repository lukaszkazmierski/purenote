import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/core/config/theme/app_themes.dart';
import 'package:notebook/core/constants/constants.dart';
import 'package:notebook/service_locator/service_locator.dart';
import 'package:provider/provider.dart';

import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';

abstract class BookNameFormDialogType {}

class AddBookDialog implements BookNameFormDialogType {}

class RenameBookDialog implements BookNameFormDialogType {}

class BookNameFormDialog<T> extends StatelessWidget {
  final Book book;

  const BookNameFormDialog({this.book, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<BookBloc>(),
      child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.32,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        border: Border.all(width: 0, style: BorderStyle.none),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0))),
                    child: _DialogContent<T>(book: book)),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.32),
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.12,
                    height: MediaQuery.of(context).size.height * 0.12,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60))),
                    child: T == RenameBookDialog
                        ? Image.asset('assets/images/book_rename.png')
                        : Image.asset('assets/images/book_add.png'),
                  ),
                )
              ],
            ),
          )),

    );
  }
}

class _DialogContentState<T> extends State<_DialogContent> {
  final TextEditingController _nameFieldController = TextEditingController();
  String currentErr;

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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              if (_isRenameBookDialogType())
                Text('Rename book', style: lightTheme.textStyle(fontSize: 17))
              else
                Text('Creating a new book',
                    style: lightTheme.textStyle(fontSize: 17)),
              BlocBuilder<BookBloc, BookState>(
                builder: (context, builder) {
                  return TextFormField(
                    controller: _nameFieldController,
                    maxLength: Constants.maxBookTitleLength,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 4, top: 10),
                        labelText: 'book name',
                        errorText: currentErr,
                        errorMaxLines: Constants.errorMaxLines,
                        counterText: "",

                    ),
                  );
                },
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(),
                  RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel', style: lightTheme.textStyle(fontSize: 15))),
                  RawMaterialButton(
                      onPressed: () {
                        if (_isRenameBookDialogType()) {
                          context.read<BookBloc>().add(RenameBook(
                              book: widget.book,
                              name: _nameFieldController.text));
                        } else {
                          final book = BookTableCompanion(
                              name: Value<String>(_nameFieldController.text));
                          context.read<BookBloc>().add(AddingNewBook(book));
                        }
                      },
                      child: _isRenameBookDialogType()
                          ? Text('Rename', style: lightTheme.textStyle(fontSize: 15))
                          : Text('Create', style: lightTheme.textStyle(fontSize: 15))
                  )],
              )
            ],
          ),
        ));
  }

  bool _isRenameBookDialogType() {
    if (T == RenameBookDialog) {
      return true;
    } else {
      return false;
    }
  }
}

class _DialogContent<T> extends StatefulWidget {
  final Book book;

  const _DialogContent({@required this.book, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogContentState<T>();
}
