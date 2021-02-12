import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notebook/app.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';


import 'package:notebook/presentation/blocs/book_bloc.dart';
import 'package:notebook/presentation/widgets/add_item_btn.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(NotebookLocalDbImpl()),
      child: MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  final TextEditingController renameBookController = TextEditingController();

  MainLayout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('main'),
      ),
      body: _Body(),
      floatingActionButton: AddItemBtn(onPressed: () {
        final book = BookTableCompanion(name: Value<String>('s'));
        context.read<BookBloc>().add(AddingNewBook(book));
      }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.watch<BookBloc>().getAllBooks,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return CircularProgressIndicator();
              } else {
                return _BookListView(bookList: snapshot.data);
              }
          }
        },
      );

  }
}

class _BookListView extends StatelessWidget {
  final List<Book> bookList;
  const _BookListView({
    this.bookList,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
        builder: (BuildContext context, BookState builder) {
      return ListView.builder(
          itemCount: bookList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(bookList[index].name),
              trailing: PopupMenuButton<String>(
                onSelected: (action) {
                  if(action == 'Delete') {
                    context.read<BookBloc>().add(RemoveBook(bookList[index]));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <String>['Rename', 'Delete'].map((e) {
                    return PopupMenuItem<String>(
                      value: e,
                      child: Text(e),
                  );
                  }).toList();
                },
              ),
            );
          });
    });
  }
}

//ElevatedButton(onPressed: () => ExtendedNavigator.of(context).push(Routes.bookWithNotesPage)),
