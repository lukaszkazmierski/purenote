import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart' show ExtendedNavigator;
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import 'package:notebook/presentation/widgets/add_item_btn.dart';
import 'package:notebook/presentation/widgets/centered_circular_progress_indicator.dart';
import 'package:notebook/core/utils/ui/dialogs/book_name_form_dialog.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(NotebookLocalDbImpl()),
      child: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('main'),
      ),
      body: const _Body(),
      floatingActionButton: AddItemBtn(onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return WillPopScope(
                  child: BookNameFormDialog(contextWithBloc: context, typeDial: 'Add',),
                  onWillPop: () async => false);
            });
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
    return StreamBuilder(
        stream: context.read<BookBloc>().watchAllBooks,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CenteredCircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return const CenteredCircularProgressIndicator();
              } else {
                return _BookListView(bookList: snapshot.data);
              }
          }
        });
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
    return ListView.builder(
        itemCount: bookList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(bookList[index].name),
            leading: const Icon(Icons.library_books),
            onTap: () {
              ExtendedNavigator.of(context).push(Routes.bookWithNotesPage);
            },
            trailing: PopupMenuButton<String>(
              onSelected: (action) {
                if (action == 'Delete') {
                  context.read<BookBloc>().add(RemoveBook(bookList[index]));
                } else {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return WillPopScope(
                            child: BookNameFormDialog(contextWithBloc: context, typeDial: 'Rename',),
                            onWillPop: () async => false);
                      }).then((name) => context.read<BookBloc>().add(RenameBook(book: bookList[index],name: name as String)));

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
  }
}
